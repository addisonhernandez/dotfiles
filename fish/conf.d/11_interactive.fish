if status is-interactive
    # Expand `... -> cd ../../` and `.... -> cd ../../../`, etc.
    abbr --add dotdot --regex '^\.\.+$' --function multicd

    # Set vim as default editor
    set -gx EDITOR $(command -v vim)
    set -gx VISUAL $(command -v vim)

    # Use Atuin shell history tool, if installed
    if command -q atuin
        atuin init fish | source
    end
end

