set -x SHELL /bin/bash

if status is-interactive
    eval (/opt/homebrew/bin/brew shellenv)
end

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/opm005795/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
[ -s "/Users/opm005795/.jabba/jabba.fish" ]; and source "/Users/opm005795/.jabba/jabba.fish"

function fish_user_key_bindings
    bind \c] peco_select_history
    bind \cr peco_select_history
end

alias docker-compose="docker compose"
