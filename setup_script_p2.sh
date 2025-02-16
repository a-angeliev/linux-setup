#!/bin/bash

# Install VS Code
read -p "Do you want to install Visual Studio Code? (y/n): " INSTALL_VSCODE
if [[ "$INSTALL_VSCODE" == "y" ]]; then
    echo "Installing Visual Studio Code..."
    sudo apt-get install wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg
    sudo apt install apt-transport-https
    sudo apt update
    sudo apt install code
else
    echo "Skipping Visual Studio Code installation."
fi

# Install git
read -p "Do you want to configure Git with your name and email? (y/n): " INSTALL_GIT
if [[ "$INSTALL_GIT" == "y" ]]; then
    echo "Configuring Git..."
    git config --global user.name "a-angeliev"
    git config --global user.email "a-angeliev@"
else
    echo "Skipping Git configuration."
fi

# Install git
read -p "Do you want to install zsh useful plugins - autosuggestions and more? (y/n): " PLUGINS
if [[ "$PLUGINS" == "y" ]]; then
    echo "Installing plugins..."
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    sed -i 's/^plugins=(.*)$/plugins=(git zsh-autosuggestions zsh-syntax-highlighting history)/' ~/.zshrc 
else
    echo "Skipping instalation of zsh plugins."
fi

# Setup keyboard shortcuts for GNOME
read -p "Do you want to setup GNOME keyboard shortcuts? (y/n): " SETUP_KEYBINDINGS
if [[ "$SETUP_KEYBINDINGS" == "y" ]]; then
    echo "Setting up GNOME keyboard shortcuts..."
    gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Alt>1']"
    gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Alt>2']"
    gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Alt>3']"
    gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Alt>4']"
    gsettings set org.gnome.shell.keybindings switch-to-application-5 "['<Alt>5']"
    gsettings set org.gnome.shell.keybindings switch-to-application-6 "['<Alt>6']"
    gsettings set org.gnome.shell.keybindings switch-to-application-7 "['<Alt>7']"
    gsettings set org.gnome.shell.keybindings switch-to-application-8 "['<Alt>8']"
    gsettings set org.gnome.shell.keybindings switch-to-application-9 "['<Alt>9']"
    gsettings set org.gnome.shell.keybindings open-new-window-application-1 "['<Ctrl><Alt>1']"
    gsettings set org.gnome.shell.keybindings open-new-window-application-2 "['<Ctrl><Alt>2']"
    gsettings set org.gnome.shell.keybindings open-new-window-application-3 "['<Ctrl><Alt>3']"
    gsettings set org.gnome.shell.keybindings open-new-window-application-4 "['<Ctrl><Alt>4']"
    gsettings set org.gnome.shell.keybindings open-new-window-application-5 "['<Ctrl><Alt>5']"
    gsettings set org.gnome.shell.keybindings open-new-window-application-6 "['<Ctrl><Alt>6']"
    gsettings set org.gnome.shell.keybindings open-new-window-application-7 "['<Ctrl><Alt>7']"
    gsettings set org.gnome.shell.keybindings open-new-window-application-8 "['<Ctrl><Alt>8']"
    gsettings set org.gnome.shell.keybindings open-new-window-application-9 "['<Ctrl><Alt>9']"
    gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super>s']"
else
    echo "Skipping GNOME keyboard shortcut setup."
fi

# Install Docker
read -p "Do you want to install Docker? (y/n): " INSTALL_DOCKER
if [[ "$INSTALL_DOCKER" == "y" ]]; then
    echo "Installing Docker..."
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install docker-ce -y
    sudo usermod -aG docker $USER
else
    echo "Skipping Docker installation."
fi

# Change system settings for GNOME
read -p "Do you want to set the default theme to dark mode? (y/n): " SET_DARK_THEME
if [[ "$SET_DARK_THEME" == "y" ]]; then
    echo "Setting the default theme to dark mode..."
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
else
    echo "Skipping dark mode setup."
fi

# Set Background
read -p "Do you want to set a custom background image? (y/n): " SET_BACKGROUND
if [[ "$SET_BACKGROUND" == "y" ]]; then
    BACKGROUND_IMAGE="$(pwd)/wallpaper.jpg"
    if [[ -f "$BACKGROUND_IMAGE" ]]; then
        echo "Setting desktop wallpaper to $BACKGROUND_IMAGE..."
        gsettings set org.gnome.desktop.background picture-uri "file://$BACKGROUND_IMAGE"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$BACKGROUND_IMAGE"
    else
        echo "No background image found at $BACKGROUND_IMAGE"
    fi
else
    echo "Skipping background setup."
fi

# Change scrolling direction
read -p "Do you want to set the scrolling direction to non-natural? (y/n): " SET_SCROLLING
if [[ "$SET_SCROLLING" == "y" ]]; then
    echo "Setting the scroll direction to non-natural..."
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
else
    echo "Skipping scroll direction setup."
fi

echo "Part 2 setup complete!"
