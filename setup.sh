# I dont use .config for my "important" dotfiles
ls ~/.config/nvim    || ln -s ~/Sync/Rice/nvim ~/.config/nvim
ls ~/.config/awesome || ln -s ~/Sync/Rice/awesome ~/.config/awesome
ls ~/.config/ranger  || ln -s ~/Sync/Rice/ranger ~/.config/ranger
ls ~/.config/neomutt || ln -s ~/Sync/Rice/neomutt ~/.config/neomutt
ls ~/.config/picom   || ln -s ~/Sync/Rice/picom ~/.config/picom

### Setup zsh
ln -s ~/Sync/Rice/zsh/zshtheme ~/.config/oh-my-zsh/themes/mh2.zsh-theme
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/oh-my-zsh/custom/plugins/zsh-syntax-highlighting

### Setup awesome
chmod +x ./awesome/scripts/*.sh
