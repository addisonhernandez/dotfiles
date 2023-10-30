if status is-interactive
    # Expand `... -> cd ../../` and `.... -> cd ../../../`, etc.
    abbr --add dotdot --regex '^\.\.$' --function multicd

    # Set vim as default editor
    set EDITOR $(command -v vim)
    set VISUAL $(command -v vim)

    # pnpm
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"
    fish_add_path --path --prepend $PNPM_HOME

    # Volta
    set -gx VOLTA_HOME "$HOME/.volta"
    fish_add_path --path --prepend "$VOLTA_HOME/bin"
end
