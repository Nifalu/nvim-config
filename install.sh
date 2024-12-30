#!/bin/bash

echo "Setting up Neovim configuration..."

# Create config directory if it doesn't exist
mkdir -p ~/.config

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo "Installing required packages..."
    brew install neovim ripgrep fd node git
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    # Check for apt (Debian/Ubuntu)
    if command -v apt &> /dev/null; then
        echo "Installing required packages..."
        sudo apt update
        sudo apt install -y neovim ripgrep fd-find nodejs npm git curl
    # Check for dnf (Fedora)
    elif command -v dnf &> /dev/null; then
        echo "Installing required packages..."
        sudo dnf install -y neovim ripgrep fd-find nodejs npm git curl
    # Check for pacman (Arch)
    elif command -v pacman &> /dev/null; then
        echo "Installing required packages..."
        sudo pacman -Sy neovim ripgrep fd nodejs npm git curl
    else
        echo "Unsupported Linux distribution. Please install the following packages manually:"
        echo "neovim ripgrep fd-find nodejs git curl"
        exit 1
    fi
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

# Verify node installation
if ! command -v node &> /dev/null; then
    echo "Node.js installation failed. Please install Node.js manually."
    exit 1
fi

# Backup existing Neovim config if it exists
if [ -d ~/.config/nvim ]; then
    echo "Backing up existing Neovim configuration..."
    mv ~/.config/nvim ~/.config/nvim.bak.$(date +%Y%m%d_%H%M%S)
fi

# Clone configuration
echo "Cloning Neovim configuration..."
git clone https://github.com/Nifalu/nvim-config.git ~/.config/nvim

echo "Setup complete!"
echo "Please start Neovim and run :Lazy sync to install plugins"
echo "To set up Copilot, run :Copilot setup after installing plugins"
