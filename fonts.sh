# ------------------------------------------------------------------------------
# Install MesloLGS Nerd Font
# ------------------------------------------------------------------------------

echo "Installing MesloLGS Nerd Font..."

NERD_FONT_DIR="$HOME/.local/share/fonts/MesloLGS"
NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"

mkdir -p "$NERD_FONT_DIR"
cd "$NERD_FONT_DIR"

# Download and unzip the font if not already installed
if [ ! -f "${NERD_FONT_DIR}/MesloLGS NF Regular.ttf" ]; then
  wget -q --show-progress "$NERD_FONT_URL" -O Meslo.zip
  unzip -o Meslo.zip
  rm Meslo.zip
  fc-cache -fv > /dev/null
  echo "MesloLGS Nerd Font installed successfully."
else
  echo "MesloLGS Nerd Font already installed. Skipping..."
fi

