## Tmux auto-start with neofetch
if test -z "$TMUX"
    # Launch tmux with neofetch as the initial command
    exec tmux new-session "fastfetch; fish" 
end

#aliases are still remaining

# Path settings (Fish uses a different syntax for PATH)
fish_add_path /home/javierrsantoss/.local/bin
fish_add_path /home/javierrsantoss/go/bin
fish_add_path /usr/local/go/bin
fish_add_path $HOME/.local/share/jdtls/bin

# Set up fzf (Ctrl+R functionality)
if test -f /usr/share/fzf/shell/key-bindings.fish
    source /usr/share/fzf/shell/key-bindings.fish
end

# NVM settings for Fish (requires additional plugin)
set -gx NVM_DIR "$HOME/.nvm"

# Colors
set -U fish_color_command ff4f00      # Commands in main orange (ff4f00)
set -U fish_color_user ff7b38         # Username in lighter orange
set -U fish_color_host ff6c21         # Hostname in medium orange
set -U fish_color_cwd ff4f00          # Current directory in main orange
set -U fish_color_error ff2929        # Errors in red-orange


set -U fish_greeting "
                  _    ___  ____  
  ___  __ _ _ __ | |_ / _ \/ ___| 
 / __|/ _` | '_ \| __| | | \___ \ 
 \__ \ (_| | | | | |_| |_| |___) |
 |___/\__,_|_| |_|\__|\___/|____/ 
                                  
"


# aliases
alias ll='ls -la'
alias gs='git status'
alias gd='git diff'

alias uni='cd ~/javie/uni/4'
alias downloads='cd ~/Downloads'

alias prog='cd ~/prog'
alias py='cd ~/prog/python'
alias fakecount='cd ~/prog/projects/fakecount'
alias fot='cd ~/prog/projects/friends-on-tour'
alias tfg='cd ~/javie/uni/4/tfg'
alias infantem='cd ~/prog/projects/infantem'
alias mcp='cd ~/prog/projects/mcp-servers'

alias pd='~/copy_token.sh'
alias mariadb_pd='~/copy_mariadb_root.sh'

alias venv='source ./venv/bin/activate.fish'
alias mysql_root='sudo mysql -u root -p'

alias fishrc='nvim ~/.config/fish/config.fish'

alias mvnwrun='./mvnw spring-boot:run'
alias mvnwclean='./mvnw clean install'

alias runserver='python ./manage.py runserver'
alias migrate='python ./manage.py migrate'
alias makemigrations='python ./manage.py makemigrations'
alias djangoshell='python ./manage.py shell'
alias rmigrations='find . -path "*/migrations/*.py" -not -name "__init__.py" -delete; find . -path "*/migrations/*.pyc"  -delete'
alias fakecount_venv='source ./../.venv/bin/activate'

alias umlet='java -jar ~/javie/Umlet/umlet.jar'
alias knime='~/Downloads/knime_5.4.1/knime'
alias cursor='~/Downloads/Cursor-0.47.9-x86_64.AppImage'

alias pinga='ping -c 1 8.8.8.8'

alias zen="~/Downloads/zen-x86_64.AppImage"
alias vim="nvim"

alias initlua="cd ~/.config/nvim";
alias tkill='tmux kill-session -t';
alias mongo='cd ~/prog/mongo-sharded';

export EDITOR=nvim
export VISUAL=nvim


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
