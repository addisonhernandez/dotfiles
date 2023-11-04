function takedir --description 'Create a new directory and cd into it' --argument dirname
    set -f dirname (path resolve $dirname)
    mkdir -p $dirname && cd $dirname
end
