echo 'First installing vim-plug'
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;
echo 'Linking vimrc to ~/.vimrc'
ln -s $(pwd)/vimrc ~/.vimrc
