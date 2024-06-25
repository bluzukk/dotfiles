ls ~/.config/awesome || ln -s ~/Sync/Rice/awesome-default ~/.config/awesome
ls ~/.config/nvim || ln -s ~/Sync/Rice/nvim ~/.config/nvim
ls ~/.config/lf || ln -s ~/Sync/Rice/lf ~/.config/lf
ls ~/.config/neomutt || ln -s ~/Sync/Rice/neomutt ~/.config/neomutt
ls ~/.config/picom || ln -s ~/Sync/Rice/picom ~/.config/picom
ls ~/.config/kitty || ln -s ~/Sync/Rice/kitty ~/.config/kitty

ln -s ~/Sync/Rice/zsh/zshtheme ~/.oh-my-zsh/themes/mh2.zsh-theme
ln -s ~/Sync/Rice/zsh/zshrc ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Setup awesome
chmod +x ~/.config/awesome/scripts/*

# Install stuff
# awesome-git alsa-utils python-pywal ttf-cascadia-code pywalfox
