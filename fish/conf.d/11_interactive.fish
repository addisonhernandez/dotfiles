if status is-interactive
    # Expand `... -> cd ../../` and `.... -> cd ../../../`, etc.
    abbr --add dotdot --regex '^\.\.+$' --function multicd

    # Set vim as default editor
    set -gx EDITOR $(command -v nvim)
    set -gx VISUAL $(command -v nvim)

    # Add fzf key bindings
    command -q fzf
    and source /usr/share/fzf/shell/key-bindings.fish

    # tabtab source for packages
    # uninstall by removing these lines
    test -f ~/.config/tabtab/fish/__tabtab.fish
    and . ~/.config/tabtab/fish/__tabtab.fish

    # set up atuin hook
    if command -q atuin
        atuin init fish | source
    end
end

