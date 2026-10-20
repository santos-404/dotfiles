set -U fish_greeting

# Add only installed tools, using this machine's home directory.
for dir in $HOME/.local/bin $HOME/go/bin /usr/local/go/bin \
        $HOME/.local/opt/go/bin $HOME/.local/share/jdtls/bin \
        $HOME/.bun/bin $HOME/.opencode/bin $HOME/flutter/bin $HOME/.lmstudio/bin
    if test -d "$dir"
        fish_add_path --path "$dir"
    end
end

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx BUN_INSTALL "$HOME/.bun"

if test (uname) = Darwin
    for dir in /opt/homebrew/bin /opt/homebrew/sbin /opt/homebrew/opt/libpq/bin \
            /opt/homebrew/opt/postgresql@18/bin \
            $HOME/.cs2kit/engines/sikarugir-10/wswine.bundle/bin
        if test -d "$dir"
            fish_add_path --path "$dir"
        end
    end
    # macOS .NET TLS backend, needed for the local development setup.
    set -gx DOTNET_SYSTEM_NET_SECURITY_USENETWORKFRAMEWORK 1
else if test -d /usr/share/dotnet
    set -gx DOTNET_ROOT /usr/share/dotnet
end

# Private endpoints, credentials and machine-specific overrides stay outside Git.
if test -f "$__fish_config_dir/config.local.fish"
    source "$__fish_config_dir/config.local.fish"
end

# Interactive integrations should not run in scripts or remote command shells.
if not status is-interactive
    return
end

if command -q fzf
    if fzf --fish >/dev/null 2>&1
        fzf --fish | source
    else if test -f /usr/share/fzf/shell/key-bindings.fish
        source /usr/share/fzf/shell/key-bindings.fish
    end
end

# NVM settings for Fish (requires additional plugin)
set -gx NVM_DIR "$HOME/.nvm"

# Colors
set -U fish_color_command ff4f00      # Commands in main orange (ff4f00)
set -U fish_color_user ff7b38         # Username in lighter orange
set -U fish_color_host ff6c21         # Hostname in medium orange
set -U fish_color_cwd ff4f00          # Current directory in main orange
set -U fish_color_error ff2929        # Errors in red-orange

# aliases
alias ll='ls -la'
alias gs='git status'
alias gd='git diff'
alias lg="lazygit"

alias downloads='cd ~/Downloads'

alias prog='cd ~/prog'
alias py='cd ~/prog/python'

alias pd='~/copy_token.sh'
alias mariadb_pd='~/copy_mariadb_root.sh'

alias venv='source ./.venv/bin/activate.fish'
alias mysql_root='sudo mysql -u root -p'

alias fishrc='nvim ~/.config/fish/config.fish'
alias sourcefish='source $HOME/.config/fish/config.fish'
alias dotfiles='cd $HOME/dotfiles'

alias runserver='python ./manage.py runserver'
alias migrate='python ./manage.py migrate'
alias makemigrations='python ./manage.py makemigrations'
alias djangoshell='python ./manage.py shell'
alias rmigrations='find . -path "*/migrations/*.py" -not -name "__init__.py" -delete; find . -path "*/migrations/*.pyc"  -delete'
alias fakecount_venv='source ./../.venv/bin/activate.fish'
alias pinga='ping -c 1 8.8.8.8'

alias vim="nvim"

alias initlua="cd ~/.config/nvim"
alias tkill='tmux kill-session -t'

alias oc='opencode'
alias cc='claude'

if test (uname) = Darwin
    alias battery='pmset -g batt'
    alias investments='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/investments'
end

# Optional, machine-local envman installation.
if test -s "$HOME/.config/envman/load.fish"
    source "$HOME/.config/envman/load.fish"
end

if command -q zoxide
    zoxide init fish | source
    alias cd='z'
end
