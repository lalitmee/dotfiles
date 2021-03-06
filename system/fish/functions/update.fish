# Defined via `source`
function update --wraps='sudo apt-fast update && sudo apt-fast upgrade -y' --description 'alias update=sudo apt-fast update && sudo apt-fast upgrade -y'
  sudo apt-fast update && sudo apt-fast upgrade -y $argv; 
end
