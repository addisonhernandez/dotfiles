if status is-interactive
    # Expand `... -> cd ../../` and `.... -> cd ../../../`, etc.
    abbr --add dotdot --regex '^\.\.$' --function multicd

    # Set vim as default editor
    set EDITOR $(command -v vim)
    set VISUAL $(command -v vim)

    # pnpm
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"
    if not contains $PNPM_HOME $PATH
        set -gx PATH $PNPM_HOME $PATH
    end

    # Volta
    set -gx VOLTA_HOME "$HOME/.volta"
    if not contains "$VOLTA_HOME/bin" $PATH
        set -gx PATH "$VOLTA_HOME/bin" $PATH
    end
end
