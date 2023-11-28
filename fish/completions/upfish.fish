# Completions for my custom update function, upfish

set --local upfish_path /home/addison/.config/fish/functions/upfish.fish

complete --short-option h --long-option help --description "Print a help message and exit" upfish
complete --short-option C --long-option noclean --description "Skip the package cleanup routine" upfish
complete --short-option y --long-option yes --description "Upgrade apt packages without prompting" upfish
complete --short-option c --long-option cargo --description "Update cargo packages" upfish
complete --short-option F --long-option prompt-flatpak --description "Prompt for flatpak upgrades" upfish

