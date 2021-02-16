" let g:barow = {
"       \  'modes': {
"       \    'normal': [' ', 'BarowNormal'],
"       \    'insert': ['i', 'BarowInsert'],
"       \    'replace': ['r', 'BarowReplace'],
"       \    'visual': ['v', 'BarowVisual'],
"       \    'v-line': ['l', 'BarowVisual'],
"       \    'v-block': ['b', 'BarowVisual'],
"       \    'select': ['s', 'BarowVisual'],
"       \    'command': ['c', 'BarowCommand'],
"       \    'shell-ex': ['!', 'BarowCommand'],
"       \    'terminal': ['t', 'BarowTerminal'],
"       \    'prompt': ['p', 'BarowNormal'],
"       \    'inactive': [' ', 'BarowModeNC']
"       \  },
"       \  'statusline': ['Barow', 'BarowNC'],
"       \  'tabline': ['BarowTab', 'BarowTabSel', 'BarowTabFill'],
"       \  'buf_name': {
"       \    'empty': '',
"       \    'hi': ['BarowBufName', 'BarowBufNameNC']
"       \  },
"       \  'read_only': {
"       \    'value': 'ro',
"       \    'hi': ['BarowRO', 'BarowRONC']
"       \  },
"       \  'buf_changed': {
"       \    'value': '*',
"       \    'hi': ['BarowChange', 'BarowChangeNC']
"       \  },
"       \  'tab_changed': {
"       \    'value': '*',
"       \    'hi': ['BarowTChange', 'BarowTChangeNC']
"       \  },
"       \  'line_percent': {
"       \    'hi': ['BarowLPercent', 'BarowLPercentNC']
"       \  },
"       \  'row_col': {
"       \    'hi': ['BarowRowCol', 'BarowRowColNC']
"       \  },
"       \  'modules': [
"       \    [ 'barowGit#branch', 'BarowHint' ],
"       \    [ 'barowLSP#error', 'BarowError' ],
"       \    [ 'barowLSP#warning', 'BarowWarning' ],
"       \    [ 'barowLSP#info', 'BarowInfo' ],
"       \    [ 'barowLSP#hint', 'BarowHint' ],
"       \    [ 'barowLSP#coc_status', 'StatusLine' ],
"       \    [ 'barowLSP#ale_status', 'StatusLine' ]
"       \  ]
"       \}

let g:barow = {
      \  'modes': {
      \    'normal': [' ', 'BarowNormal'],
      \    'insert': ['i', 'BarowInsert'],
      \    'replace': ['r', 'BarowReplace'],
      \    'visual': ['v', 'BarowVisual'],
      \    'v-line': ['l', 'BarowVisual'],
      \    'v-block': ['b', 'BarowVisual'],
      \    'select': ['s', 'BarowVisual'],
      \    'command': ['c', 'BarowCommand'],
      \    'shell-ex': ['!', 'BarowCommand'],
      \    'terminal': ['t', 'BarowTerminal'],
      \    'prompt': ['p', 'BarowNormal'],
      \    'inactive': [' ', 'BarowModeNC']
      \  },
      \  'statusline': ['Barow', 'BarowNC'],
      \  'tabline': ['BarowTab', 'BarowTabSel', 'BarowTabFill'],
      \  'buf_name': {
      \    'empty': '',
      \    'hi': ['BarowBufName', 'BarowBufNameNC']
      \  },
      \  'read_only': {
      \    'value': 'ro',
      \    'hi': ['BarowRO', 'BarowRONC']
      \  },
      \  'buf_changed': {
      \    'value': '*',
      \    'hi': ['BarowChange', 'BarowChangeNC']
      \  },
      \  'tab_changed': {
      \    'value': '*',
      \    'hi': ['BarowTChange', 'BarowTChangeNC']
      \  },
      \  'line_percent': {
      \    'hi': ['BarowLPercent', 'BarowLPercentNC']
      \  },
      \  'row_col': {
      \    'hi': ['BarowRowCol', 'BarowRowColNC']
      \  },
      \  'modules': [
      \    [ 'barowGit#branch', 'BarowHint' ],
      \    [ 'barowLSP#error', 'BarowError' ],
      \    [ 'barowLSP#warning', 'BarowWarning' ],
      \    [ 'barowLSP#info', 'BarowInfo' ],
      \    [ 'barowLSP#hint', 'BarowHint' ],
      \  ]
      \}
