import * as cp from 'child_process';
import * as path from 'path';
import * as os from 'os';
import { assert } from 'chai';

describe('typings', () => {
  it('compiles successfully', function (): void {
    this.timeout(10000);
    const command = os.platform() === 'win32' ? 'tsc.cmd' : 'tsc';
    const result = cp.spawnSync(command, { cwd: path.resolve('./fixtures/typings-test')});
    assert.equal(result.status, 0, `build did not succeed:\nstdout: ${String(result.stdout)}\nstderr: ${String(result.stderr)}\n`);
  });
});
