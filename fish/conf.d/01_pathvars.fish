# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path --path --prepend $PNPM_HOME

# Volta
set -gx VOLTA_HOME "$HOME/.volta"
fish_add_path --path --prepend "$VOLTA_HOME/bin"

