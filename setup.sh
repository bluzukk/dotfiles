# I dont use .config for my "important" dotfiles
ls ~/.config/awesome || ln -s ~/Sync/Rice/awesome ~/.config/awesome
ls ~/.config/nvim    || ln -s ~/Sync/Rice/nvim ~/.config/nvim
ls ~/.config/lf      || ln -s ~/Sync/Rice/lf ~/.config/lf
ls ~/.config/neomutt || ln -s ~/Sync/Rice/neomutt ~/.config/neomutt
ls ~/.config/picom   || ln -s ~/Sync/Rice/picom ~/.config/picom

# Setup zsh
ln -s ~/Sync/Rice/zsh/zshtheme ~/.oh-my-zsh/themes/mh2.zsh-theme
ln -s ~/Sync/Rice/zsh/zshrc    ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Setup awesome
chmod +x ./awesome/scripts/*

# Install stuff
pacman -S alsa-utils awesome-git cascadia-code pywal pywalfox

