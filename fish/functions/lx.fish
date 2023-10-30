#function lx --wraps=ls --description 'List almost all contents of directory, including hidden files, in long format, with classification indicators and human-readable sizes'
#    ls -lhAXF --group-directories-first $argv
#    ls --almost-all --classify --human-readable --format=long --sort=extension
#end

function lx \
    --wraps=eza \
    --description 'List almost all contents of a directory, including hidden files, in long format, with classification indicators'
    eza \
        --classify \
        --long \
        --all \
        --sort=type \
        --group-directories-first \
        --header \
        --git \
        $argv
end
