#!/bin/bash

# Prompt user to install Oh My Zsh
read -p "Do you want to install git? (y/n): " INSTALL_GIT
if [[ "$INSTALL_GIT" == "y" ]]; then
    echo "Installing Git..."
    sudo apt update $$ sudo apt install git
else
    echo "Skipping Git installation."
fi

# Prompt user to proceed with Zsh installation
read -p "Do you want to install and set Zsh as your default shell? (y/n): " INSTALL_ZSH
if [[ "$INSTALL_ZSH" == "y" ]]; then
    echo "Installing Zsh..."
    sudo apt update && sudo apt install zsh -y
    echo "Changing default shell to zsh..."
    chsh -s $(which zsh)
    echo "Zsh installation complete! Please restart your terminal."
else
    echo "Skipping Zsh installation."
fi

# Prompt user to install Oh My Zsh
read -p "Do you want to install Oh My Zsh? (y/n): " INSTALL_OHMYZSH
if [[ "$INSTALL_OHMYZSH" == "y" ]]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
else
    echo "Skipping Oh My Zsh installation."
fi

# Install Powerlevel10k theme
read -p "Do you want to install Powerlevel10k theme for Zsh? (y/n): " INSTALL_P10K
if [[ "$INSTALL_P10K" == "y" ]]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
    echo "Powerlevel10k theme installed."
else
    echo "Skipping Powerlevel10k installation."
fi

# Install Nerd Font
read -p "Do you want to install MesloLGS Nerd Font? (y/n): " INSTALL_FONT
if [[ "$INSTALL_FONT" == "y" ]]; then
    echo "Installing MesloLGS Nerd Font..."
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
    unzip -o Meslo.zip
    rm Meslo.zip
    fc-cache -fv
else
    echo "Skipping MesloLGS Nerd Font installation."
fi

read -p "Do you want to install NVM and Node.js? (y/n): " INSTALL_NODE
if [[ "$INSTALL_NODE" == "y" ]]; then
    echo "Installing prerequisites..."

    # Update system and install necessary packages
    sudo apt update
    sudo apt install -y curl build-essential libssl-dev

    echo "Installing NVM..."

    # Install NVM using curl
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | zsh

    # Source NVM scripts to make it available in the current session
	if ! grep -q 'export NVM_DIR="$HOME/.nvm"' ~/.zshrc; then
       	 	echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
        	echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.zshrc
    	fi
    echo "NVM installation complete."

    # Prompt the user to install the latest LTS version of Node.js
    echo "Installing the latest LTS version of Node.js using NVM..."

    # Install the latest LTS version using NVM
    nvm install --lts

    # Set the latest LTS version as the default Node.js version
    nvm alias default node

    echo "Node.js and NVM installation complete."

    # Verify Node.js and npm installation
    node -v
    npm -v
else
    echo "Skipping NVM and Node.js installation."
fi

# Configure the terminal look
read -p "Do you want to apply terminal theme? (y/n): " CONFIG_TERM
if [[ "$CONFIG_TERM" == "y" ]]; then
    echo "Configuration the terminal"
    
    PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList list | tr -d "[]',")
	# Use pl10k font
	dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/use-system-font false
	dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/font "'MesloLGM Nerd Font 12'"
	
	# Set palette and use it
	dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/use-theme-colors false
	dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/palette "['#262626', '#E356A7', '#42E66C', '#E4F34A', '#9B6BDF', '#E64747', '#75D7EC', '#EFA554', '#7A7A7A', '#FF79C6', '#50FA7B', '#F1FA8C', '#BD93F9', '#FF5555', '#8BE9FD', '#FFB86C']"

	# Set text (foreground) color to #F8F8F2 (light text)
	dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/foreground-color "'#F8F8F2'"

	# Set background color to #282A36 (dark background)
	dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/background-color "'#282A36'"

	# Enable bold text and set bold color to #6E46A4
	dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/bold-color-same-as-fg false
	dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/bold-color "'#6E46A4'"

	# Disable system theme transparency
	dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/use-theme-transparency false

	# Enable transparency and set it to 15%
	dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/use-transparent-background true
	dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/background-transparency-percent 15
	
	# Expand the terminal window default size
	dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/default-size-columns 170
	dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/default-size-rows 30
else
    echo "Skipping terminal theme configuration."
fi

echo "Part 1 setup complete! Please restart your terminal to apply the changes."
