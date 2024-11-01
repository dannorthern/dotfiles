#!/bin/bash

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    echo "Homebrew installed successfully."
else
    echo "Homebrew is already installed."
fi

# Run Homebrew bundle
brew bundle

# NVM Setup
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Install latest LTS version of Node.js
nvm install --lts

# Lando Setup
if ! command -v lando &> /dev/null; then
    echo "Lando is not installed. Installing Lando..."
    
    # Install Lando using the official installation script
    /bin/bash -c "$(curl -fsSL https://get.lando.dev/setup-lando.sh)"
    
    echo "Lando has been installed."
else
    echo "Lando is already installed."
fi

# Ensure Lando's bin directory is in PATH
if ! grep -q "export PATH=\"\$PATH:/usr/local/bin\"" "$HOME/.zshrc"; then
    echo "" >> "$HOME/.zshrc"
    echo "# Ensure Lando is in PATH" >> "$HOME/.zshrc"
    echo 'export PATH="$PATH:/usr/local/bin"' >> "$HOME/.zshrc"
    echo "Lando PATH added to .zshrc"
else
    echo "Lando PATH already exists in .zshrc"
fi

# Oh My Zsh Setup
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# Append NVM configuration to .zshrc if it's not already there
if ! grep -q "NVM_DIR" "$HOME/.zshrc"; then
    echo "" >> "$HOME/.zshrc"
    echo "# NVM configuration" >> "$HOME/.zshrc"
    echo 'export NVM_DIR="$HOME/.nvm"' >> "$HOME/.zshrc"
    echo '[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm' >> "$HOME/.zshrc"
    echo '[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion' >> "$HOME/.zshrc"
    echo "NVM configuration added to .zshrc"
else
    echo "NVM configuration already exists in .zshrc"
fi


echo "Setup complete. Please restart your terminal or run 'source ~/.zshrc' to apply changes."