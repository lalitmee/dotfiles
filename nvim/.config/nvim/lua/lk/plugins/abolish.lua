local nmap = lk.nmap
local vmap = lk.vmap
-----------------------------------------------------------------------------//
-- Abolish
-----------------------------------------------------------------------------//
-- Find and Replace Using Abolish Plugin %S - Subvert
-----------------------------------------------------------------------------//
nmap("<localleader>[", ":S/<c-r><c-w>//<left>")
nmap("<localleader>]", ":%S/<c-r><c-w>//c<left><left>")
vmap("<localleader>[", [["zy:%S/<c-r><c-o>"//c<left><left>]])
