#!/bin/sh
# claude-image-gen installer for macOS and Linux:
#   curl -fsSL https://raw.githubusercontent.com/jonjoncheese/claude-image-gen/main/install.sh | sh
set -eu
SRC="${CIG_REPO:-https://raw.githubusercontent.com/jonjoncheese/claude-image-gen/main}"
DIR="${CIG_INSTALL_DIR:-$HOME/.local/share/claude-image-gen}"
BIN="${CIG_BIN_DIR:-$HOME/.local/bin}"

node_ok() { command -v node >/dev/null 2>&1 && [ "$(node -p 'process.versions.node.split(".")[0]')" -ge 22 ]; }
if ! node_ok; then
  if command -v brew >/dev/null 2>&1; then
    echo "Installing Node.js with Homebrew..."
    brew install node
  fi
  if ! node_ok; then
    echo "claude-image-gen needs Node.js 22 or newer. Install it from https://nodejs.org, then run this again." >&2
    exit 1
  fi
fi

mkdir -p "$DIR" "$BIN"
curl -fsSL "$SRC/claude-image-gen.js" -o "$DIR/claude-image-gen.js"
printf '#!/bin/sh\nexec node "%s/claude-image-gen.js" "$@"\n' "$DIR" > "$BIN/claude-image-gen"
chmod +x "$BIN/claude-image-gen"
echo "Installed claude-image-gen $(node "$DIR/claude-image-gen.js" --version) at $BIN/claude-image-gen"

case ":$PATH:" in
  *":$BIN:"*) ;;
  *) echo "Add it to your PATH:  echo 'export PATH=\"$BIN:\$PATH\"' >> ~/.zshrc   (bash: ~/.bashrc), then open a new terminal." ;;
esac
echo "Next: claude-image-gen login"
