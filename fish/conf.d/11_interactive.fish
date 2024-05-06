if status is-interactive
    # Expand `... -> cd ../../` and `.... -> cd ../../../`, etc.
    abbr --add dotdot --regex '^\.\.+$' --function multicd

    # Set vim as default editor
    set -gx EDITOR $(command -v nvim)
    set -gx VISUAL $(command -v nvim)

    # Add fzf key bindings
    command -q fzf
    and source /usr/share/fzf/shell/key-bindings.fish
end

