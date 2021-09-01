local map = lk_utils.map
-----------------------------------------------------------------------------//
-- Abolish
-----------------------------------------------------------------------------//
-- Find and Replace Using Abolish Plugin %S - Subvert
-----------------------------------------------------------------------------//
map('n', '<localleader>[', ':S/<c-r><c-w>//<left>')
map('n', '<localleader>]', ':%S/<c-r><c-w>//c<left><left>')
map('v', '<localleader>[', [["zy:%S/<c-r><c-o>"//c<left><left>]])
