function __print_header \
    --argument-names message \
    --description "Print a message surrounded with `#`"

    set --local header "#  $message  #"
    set --local header_length (string length $header)
    set --local padding (string repeat --count $header_length "#")

    echo (set_color $fish_color_quote)
    echo -e "\t$padding"
    echo -e "\t$header"
    echo -e "\t$padding"
    echo (set_color normal)
end
