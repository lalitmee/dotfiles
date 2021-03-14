from kitty import cli, constants, fast_data_types

def main(args):
    pass

def handle_result(kargs, answer, target_window_id, boss):
    args, rest = cli.parse_args([])
    opts = cli.create_opts(args)
    boss.keymap = opts.keymap.copy()
    fast_data_types.set_options(opts, constants.is_wayland(), args.debug_rendering,
                                args.debug_font_fallback)

handle_result.no_ui = True
