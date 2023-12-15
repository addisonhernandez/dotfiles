function upfish --description "Update system packages and tools all at once"

    set USAGE "
    Usage: $(set_color --bold $fish_color_command)upfish$(set_color --bold $fish_color_param) [OPTION...]$(set_color normal)

    Options:
        When run with no options, prompt for input at the appropriate times
        -h | --help             Print this help message and exit
        -C | --noclean          Skip the package cleanup routine
        -y | --yes              Proceed with package install or upgrade without prompting
        -c | --cargo            Update cargo packages
        -F | --prompt-flatpak   Prompt for flatpak install or upgrade
    "

    ## Args ##

    argparse h/help C/noclean y/yes c/cargo F/prompt-flatpak -- $argv; or return

    if set --query _flag_help
        echo $USAGE
        return 0
    end

    if not fish_is_root_user
        sudo echo -n ""
    end

    set --function --export error_log (mktemp)

    ## Helpers ##

    function _print_header \
        --argument-names message \
        --description "Print a message surrounded with #"

        set --local header "#  $message  #"
        set --local padding (string repeat --count (string length $header) "#")

        echo -e (set_color $fish_color_quote)"\n\t$padding\n\t$header\n\t$padding\n"(set_color normal)
    end

    function _print_error \
        --argument-names message \
        --description "Log an error message to stdout, stderr, and a log file"

        echo >&2 (set_color $fish_color_error)"[ERR]"(set_color normal) $message
        echo $message >>$error_log
    end

    function _ensure --description "Run a command and log errors to a file"
        if not $argv
            _print_error "\"$argv\" failed with status $status"
        end
    end

    function _cleanup --description "Clean up upgrade artifacts"
        if set --query _flag_noclean
            _print_header "Updates completed"
        else
            _print_header "Updates completed, performing cleanup"
            echo -n "Unused packages:       " && sudo dnf autoremove --assumeyes
            echo -n "DNF cache:             " && sudo dnf clean
            echo -n "Unused flatpaks:       " && flatpak uninstall --unused --assumeyes
        end

        if test -s $error_log
            echo (set_color $fish_color_error)"Errors found:"(set_color normal)
            bat $error_log
        end
        echo -n "Removing temp files:   "
        rm $error_log; and echo Removed

        echo -n "Cleaning /tmp dir:     "
        fd --type file --changed-before 2days --owner addison . /tmp --exec-batch rm
        and echo Cleaned

        echo "" # Leave the prompt looking cleaner
    end

    ## Upgrade Routines ##

    function upgrade_dnf \
        --inherit-variable _flag_yes

        _print_header "Upgrading DNF Packages"

        set --local _upgrade_dnf sudo dnf upgrade
        if set --query _flag_yes
            set --append _upgrade_dnf --assumeyes
        end

        _ensure $_upgrade_dnf
    end

    function upgrade_flatpak \
        --inherit-variable _flag_prompt_flatpak

        _print_header "Upgrading Flatpak Packages"

        set --local _upgrade_flatpak flatpak update
        if not set --query _flag_prompt_flatpak
            set --append _upgrade_flatpak --assumeyes
        end

        _ensure $_upgrade_flatpak
    end

    function upgrade_docker
        _print_header "Upgrading Docker Images"

        set --local _update_docker_images bash /home/addison/homelab/update_all_images.sh

        _ensure $_update_docker_images
    end

    function upgrade_rust \
        --inherit-variable _flag_cargo

        _print_header "Upgrading Rust Toolchains"

        set --local _update_rust rustup update
        _ensure $_update_rust

        if set --query _flag_cargo
            _print_header "Upgrading Rust Packages"
            cargo install (
                cargo install --list \
                    | grep --invert-match --extended-regexp "(^\s|\(.*\))" \
                    | cut --fields 1 --delimiter ' '
            )
        end
    end

    function upgrade_tldr
        _print_header "Upgrading tldr Cache"

        set --local _update_tldr tldr --update
        _ensure $_update_tldr
    end

    ## Main ##

    upgrade_dnf
    or return $status

    upgrade_flatpak
    or return $status

    upgrade_docker
    or return $status

    upgrade_rust
    or return $status

    upgrade_tldr
    or return $status

    ## Cleanup ##
    _cleanup

    return 0
end
