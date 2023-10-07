function lx --wraps=ls --description 'List almost all contents of directory, including hidden files, in long format, with classification indicators and human-readable sizes'
    ls -lhAXF --group-directories-first $argv
end
