if [ ! -d ~/.config/nvim ]; then
  mkdir -p ~/.config/nvim
fi
if [[ ! -h ~/.config/nvim/init.lua || ! -h ~/.config/nvim/lua ]]; then
  ln -s -f $SRC/dotfiles/vim/init.lua ~/.config/nvim/init.lua
  ln -s -f $SRC/dotfiles/vim/lua ~/.config/nvim/lua
fi
