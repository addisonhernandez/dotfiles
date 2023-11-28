function rusty \
    --wraps=rustc \
    --description 'Compile a rust binary, then run it and remove it' \
    --argument fname

    set -f USAGE "
    Usage: rusty <file_name>
    "

    function _print_usage_and_exit
        echo 2>&1 $USAGE
        exit 1
    end

    set --query fname
    or _print_usage_and_exit

    # $fname should take the form `example.rs` or `example`
    #
    # Make sure the file specified in $fname is in the current directory
    # and bind the filename sans `.rs` to $bin
    string match --regex --quiet -- '^(?<bin>[^\0]+?)(?:\.rs)?$' $fname
    or _print_usage_and_exit

    # ensure $fname is of the form `example.rs`
    set -f fname $bin".rs"

    # compile the source, and if successful, run the binary and remove it
    rustc $fname
    and begin
        ./$bin
        rm $bin
    end
end
