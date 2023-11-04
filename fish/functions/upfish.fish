function upfish --description "Update system packages and tools all at once"

    ## Helpers ##

    set USAGE "
    Usage: $(set_color --bold $fish_color_command)upfish$(set_color --bold $fish_color_param) [OPTION...]$(set_color normal)

    Options:
        When run with no options, prompt for input at the appropriate times
        -h | --help     Print this help message and exit
        -C | --noclean  Skip the package cleanup routine
        -y | --yes      Proceed with package install or upgrade without prompting
        -c | --cargo    Update cargo packages
    "

    function _print_header \
        --argument-names message \
        --description "Print a message surrounded with #"

        set -l header "#  $message  #"
        set -l padding (string repeat --count (string length $header) "#")

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
            echo -n "Unused packages:       " && sudo nala autoremove --assume-yes
            echo -n "Apt cache:             " && sudo nala clean
            echo -n "Unused flatpaks:       " && flatpak uninstall --unused --assumeyes
        end

        if test -s $error_log
            echo (set_color $fish_color_error)"Errors found:"(set_color normal)
            bat $error_log
        end
        echo -n "Removing temp files:   " && ( rm $error_log && echo "Done" )

        echo "" # Leave the prompt looking cleaner
    end

    ## Args ##

    argparse h/help C/noclean y/yes c/cargo -- $argv; or return

    if set --query _flag_help
        echo $USAGE
        return 0
    end

    if test $EUID -ne 0
        sudo echo -n ""
    end

    set -fx error_log (mktemp)

    ## Main ##

    # apt
    _print_header "Upgrading Apt Packages"

    set -l _upgrade_apt sudo nala upgrade
    if set --query _flag_yes
        set -a _upgrade_apt --assume-yes
    end

    _ensure $_upgrade_apt


    # flatpak
    _print_header "Upgrading Flatpak Packages"

    set -l _upgrade_flatpak flatpak update
    if set --query _flag_yes
        set -a _upgrade_flatpak --assumeyes
    end

    _ensure $_upgrade_flatpak


    # docker
    _print_header "Upgrading Docker Images"

    set -l _update_docker_images bash /home/addison/homelab/update_all_images.sh

    _ensure $_update_docker_images


    # rust toolchains
    _print_header "Upgrading Rust Toolchains"

    set -l _update_rust rustup update
    _ensure $_update_rust

    if set --query _flag_cargo
        _print_header "Upgrading Rust Packages"
        cargo install (
            cargo install --list \
                | grep --invert-match "^\s" \
                | cut --fields 1 --delimiter ' '
        )
    end


    # tldr
    _print_header "Upgrading tldr Cache"

    set -l _update_tldr tldr --update
    _ensure $_update_tldr


    ## Cleanup ##
    _cleanup

    return 0
end
