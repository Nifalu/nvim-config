#!/bin/bash

echo "Setting up Neovim configuration..."

# Create config directory if it doesn't exist
mkdir -p ~/.config

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
            echo "Homebrew installation failed."
            exit 1
        }
        # Add Homebrew to PATH for this session
        export PATH="/opt/homebrew/bin:$PATH"
    fi

    echo "Installing required packages..."
    brew install neovim ripgrep fd node git || {
        echo "Failed to install required packages via Homebrew."
        exit 1
    }

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v apt &> /dev/null; then
        echo "Installing required packages with apt..."
        sudo apt update
        sudo apt install -y neovim ripgrep fd-find nodejs npm git curl || {
            echo "Failed to install required packages with apt."
            exit 1
        }
    elif command -v dnf &> /dev/null; then
        echo "Installing required packages with dnf..."
        sudo dnf install -y neovim ripgrep fd-find nodejs npm git curl || {
            echo "Failed to install required packages with dnf."
            exit 1
        }
    elif command -v pacman &> /dev/null; then
        echo "Installing required packages with pacman..."
        sudo pacman -Sy --noconfirm neovim ripgrep fd nodejs npm git curl || {
            echo "Failed to install required packages with pacman."
            exit 1
        }
    else
        echo "Unsupported Linux distribution. Please install the following packages manually:"
        echo "neovim ripgrep fd-find nodejs git curl"
        exit 1
    fi

else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

# Verify Node.js installation
if ! command -v node &> /dev/null; then
    echo "Node.js installation failed. Please install Node.js manually."
    exit 1
fi

# Backup existing Neovim configuration if it exists
if [ -d ~/.config/nvim ]; then
    echo "Backing up existing Neovim configuration..."
    mv ~/.config/nvim ~/.config/nvim.bak.$(date +%Y%m%d_%H%M%S) || {
        echo "Failed to backup existing Neovim configuration."
        exit 1
    }
fi

# Clone Neovim configuration
echo "Cloning Neovim configuration..."
if git clone https://github.com/Nifalu/nvim-config.git ~/.config/nvim; then
    echo "Setup complete!"
    echo "Please start Neovim and run :Lazy sync to install plugins"
    echo "To set up Copilot, run :Copilot setup after installing plugins"
else
    echo "Failed to clone Neovim configuration. Please check your Git installation or network connection."
    exit 1
fi

