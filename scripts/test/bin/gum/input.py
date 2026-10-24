#!/usr/bin/env python3
"""Standalone regression checks for the shared Gum input helper."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


REPO = Path(__file__).resolve().parents[4]
HELPER = REPO / "bin/.config/bin/gum-input"


class InputTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        root = Path(self.tmp.name)
        stub = root / "gum"
        stub.write_text(
            "#!/usr/bin/env python3\n"
            "import json, os, sys\n"
            "from pathlib import Path\n"
            "Path(os.environ['ARGS']).write_text(json.dumps(sys.argv[1:]))\n"
            "Path(os.environ['STDIN']).write_text(sys.stdin.read())\n"
            "print('mock UI', file=sys.stderr)\n"
            "sys.stdout.write(os.environ.get('RESULT', ''))\n"
            "sys.exit(int(os.environ.get('STATUS', '0')))\n"
        )
        stub.chmod(0o755)
        self.root = root
        self.env = {k: v for k, v in os.environ.items() if not k.startswith('GUM_')}
        self.env.update(PATH=f"{root}:{os.environ['PATH']}",
                        ARGS=str(root / 'args'), STDIN=str(root / 'stdin'))

    def run_helper(self, *args, stdin='', **env):
        result = subprocess.run([str(HELPER), *args], input=stdin, text=True,
                                capture_output=True, env=self.env | env)
        path = self.root / 'args'
        self.args = json.loads(path.read_text()) if path.exists() else []
        return result

    def header(self):
        return next(arg.split('=', 1)[1] for arg in self.args if arg.startswith('--header='))

    def test_input_colors_header_and_password(self):
        result = self.run_helper('input', '--header', 'Remote URL', '--password',
                                 '--width', '30', '--value', 'https://example.org',
                                 RESULT='secret')
        self.assertEqual(result.returncode, 0)
        self.assertEqual(result.stdout, 'secret')
        self.assertEqual(result.stderr, 'mock UI\n')
        self.assertIn('--password', self.args)
        self.assertEqual(self.args[-4:], ['--width', '30', '--value', 'https://example.org'])
        self.assertIn('--header.foreground=#FF628C', self.args)
        self.assertIn('--cursor.foreground=#66B3FF', self.args)
        self.assertIn('--placeholder.foreground=#9E9E9E', self.args)
        self.assertIn('--no-show-help', self.args)
        self.assertIn('\033[1;38;2;255;98;140mRemote URL', self.header())
        self.assertIn('\033[1;38;2;102;179;255mEnter', self.header())
        self.assertIn('\033[38;2;255;198;0msubmit', self.header())
        self.assertNotIn('Ctrl+J', self.header())

    def test_multiline_and_stdin_are_unchanged(self):
        result = self.run_helper('write', '--height=6', '--char-limit', '0',
                                 stdin='initial\ntext', RESULT='line one\nline two\n')
        self.assertEqual(result.stdout, 'line one\nline two\n')
        self.assertEqual((self.root / 'stdin').read_text(), 'initial\ntext')
        self.assertIn('--base.foreground=#FFFFFF', self.args)
        self.assertIn('Ctrl+J', self.header())
        self.assertIn('Ctrl+E', self.header())
        self.assertNotIn('Ctrl+D', self.header())

    def test_cancellation_and_empty_submission(self):
        self.assertEqual(self.run_helper('input', STATUS='130').returncode, 130)
        result = self.run_helper('write')
        self.assertEqual((result.returncode, result.stdout), (0, ''))

    def test_header_forms_environment_and_help_opt_out(self):
        self.run_helper('input', '--header=CLI', '--no-show-help', GUM_INPUT_HEADER='ENV')
        self.assertIn('CLI', self.header())
        self.assertNotIn('ENV', self.header())
        self.assertNotIn('submit', self.header())
        self.run_helper('write', GUM_WRITE_HEADER='ENV', GUM_WRITE_SHOW_HELP='false')
        self.assertIn('ENV', self.header())
        self.assertNotIn('Ctrl+J', self.header())

    def test_option_like_values_and_explicit_style_override(self):
        self.run_helper('input', '--value', '--header', '--cursor.foreground=#123456')
        self.assertEqual(self.args[-3:], ['--value', '--header', '--cursor.foreground=#123456'])
        self.assertIn('submit', self.header())

    def test_help_is_not_decorated(self):
        self.run_helper('write', '--help')
        self.assertEqual(self.args, ['write', '--help'])

    def test_invalid_mode_and_missing_header(self):
        self.assertEqual(self.run_helper('choose').returncode, 2)
        self.assertEqual(self.run_helper('input', '--header').returncode, 2)


if __name__ == '__main__':
    unittest.main()
