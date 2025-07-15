clear

# Exit on any error
set -e

local RBENV_ROOT="$HOME/.rbenv"

# Install rbenv if not present
if [ -d "$RBENV_ROOT" ]; then
  echo "✅ rbenv already installed at $RBENV_ROOT"
else
  git clone https://github.com/rbenv/rbenv.git "$RBENV_ROOT"
  echo "✅ Cloned rbenv into $RBENV_ROOT"
fi

# Install ruby-build plugin
if [ -d "$RBENV_ROOT/plugins/ruby-build" ]; then
  echo "✅ ruby-build already installed."
else
  mkdir -p "$RBENV_ROOT/plugins"
  git clone https://github.com/rbenv/ruby-build.git "$RBENV_ROOT/plugins/ruby-build"
  echo "✅ Installed ruby-build plugin."
fi
