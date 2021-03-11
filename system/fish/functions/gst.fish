# Defined via `source`
function gst --wraps='git status' --description 'alias gst=git status'
  git status $argv; 
end
