function update_cargo_binaries --description "Update binary packages installed with cargo"

    argparse skip -- $argv
    or return 1

    __print_header "Upgrading Rust Toolchain"
    rustup update

    if not set --query _flag_skip
        __print_header "Upgrading Cargo Binaries"
        set --function cargo_binaries (
            cargo install --list \
                | grep --invert-match --extended-regexp "(^\s|\(.*\))" \
                | cut --fields 1 --delimiter ' '
            )

        for bin in $cargo_binaries
            cargo install $bin
            echo
        end
    end
end

