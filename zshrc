# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="ys"
# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git wp-cli z thefuck colored-man-pages)

# --- User configuration

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim'

export PATH="$HOME/.bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin"

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# --- Aliases

alias add-alias='echo "Please insert the new alias:"; read string; echo alias ${string} >> $HOME/.aliases; source $HOME/.aliases'
alias edit-alias='$EDITOR $HOME/.aliases; source $HOME/.aliases'

# please add custom aliases in the file below insted
source $HOME/.aliases


_refresh_paths='export PATH=$STANDARD_PATH; [[ -f $HOME/.paths ]] && source $HOME/.paths;';

#export PATH=$STANDARD_PATH;
#[[ -f $HOME/.paths ]] && source $HOME/.paths;

function add-path (){
  local normpath

  # expand the path (for example `~` -> `/home/youruser`)
  normpath=${~1}
  # transform into absolute path
  normpath=${normpath:a}

  normpath=$(echo $normpath | sed "s|$HOME|"'$HOME|')
  echo 'export PATH='"$normpath"':$PATH' >> $HOME/.paths;
  eval $_refresh_paths
}
alias edit-path='$EDITOR $HOME/.paths; eval $_refresh_paths'

# --- Custom configuration

# have NPM install global packages in the home dir
NPM_PACKAGES="${HOME}/.npm-packages"
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
PATH="$NPM_PACKAGES/bin:$PATH"
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
# add npm completions
type npm > /dev/null && eval "$(npm completion 2>/dev/null)"


# --- Utility functions

# ^Z to foreground the last suspended job.
foreground-current-job() { fg; }
zle -N foreground-current-job
bindkey -M emacs '^z' foreground-current-job
bindkey -M viins '^z' foreground-current-job
bindkey -M vicmd '^z' foreground-current-job

# make folder writable by the webserver
function wwwwrite () {
    sudo setfacl -R -m u:www-data:rwX -m u:`whoami`:rwX $1 && sudo setfacl -dR -m u:www-data:rwx -m u:`whoami`:rwx $1
}

function gh() {
    git clone https://github.com/${1}.git ${@:2}
}
function bb() {
    git clone https://bitbucket.org/${1}.git ${@:2}
}


function filewatch() {
   while inotifywait ${~1}; do ${@:2}; done;
}
alias filewatch='noglob filewatch'

_create_symfony_console_completion() {
    symfony_command_name=$1;
    symfony_resolved_command=`whence $1`
    local template=''

    read -d -r template <<\EOF
    _$symfony_command_name _get_command_list () {
        $symfony_resolved_command ....no..ansi | sed "1,/Available commands/d" | awk '/^ +[a..z]+/ { print $1 }';
        $symfony_resolved_command ....no..ansi | sed "1,/Available commands/d" | awk '/^ +[a..z]+/ { print $1 }';
    }
    _$symfony_command_name () {
        compadd `_$symfony_command_name _get_command_list`;
    }
    compdef "_$symfony_command_name" $symfony_command_name;
EOF

    template=${template:gs/../-}
    template=${template:gs/'$symfony_resolved_command'/$symfony_resolved_command}
    template=${template:gs/'$symfony_command_name'/$symfony_command_name}
    template=${template:gs/' _get_command_list'/_get_command_list}

    eval $template
}

_create_symfony_console_completion phpcomposer
alias artisan='php artisan'
_create_symfony_console_completion artisan


ask-yn()
{
    while true; do
        echo -n $1
        if [[ -n "$2" ]]; then
            [[ $2 == 0 ]] && echo -n " (y/N)" || echo -n " (Y/n)"
        else
            echo -n " (y/n)"
        fi
        echo -n " "
        read ret
        case ${ret} in
            yes|Yes|y|Y) return 0;;
            no|No|n|N)   return 1;;
            "") [[ -n $2 ]] && { [[ $2 != 0 ]] && return 0 || return 1 };;
        esac
    done
}



# credit https://gist.github.com/wancw/f6d0e6634228cd9e3da3

typeset -gaU preexec_functions
typeset -gaU precmd_functions

preexec_functions+='preexec_start_timer'
precmd_functions+='precmd_report_time'

_tr_current_cmd="?"
_tr_sec_begin="${SECONDS}"
_tr_ignored="yes"
_tr_error=0
_tr_icon_success=/usr/share/icons/hicolor/scalable/apps/im-yahoo.svg
_tr_icon_fail=/usr/share/icons/hicolor/scalable/apps/apport.svg

TIME_REPORT_THRESHOLD=${TIME_REPORT_THRESHOLD:=10}

function precmd() {
  _tr_error=$?
}

function preexec_start_timer() {
    if [[ "x$TTY" != "x" ]]; then
        _tr_current_cmd="$2"
        _tr_sec_begin="$SECONDS"
        _tr_ignored=""
    fi
}

function precmd_report_time() {
    local te
    local icon=${_tr_icon_success}
    local _status

    if [[ ${_tr_error} != 0 ]] ; then
      icon=${_tr_icon_fail}
      _status=" [status: ${_tr_error}]";
    fi


    te=$((${SECONDS}-${_tr_sec_begin}))
    if [[ "x${_tr_ignored}" = "x" && $te -gt $TIME_REPORT_THRESHOLD ]] ; then
        _tr_ignored="yes"
        echo "\n\`${_tr_current_cmd}\` completed in ${te} seconds."
        notify-send \`${_tr_current_cmd}\` "completed in <b>${te}</b> seconds.${_status}" -i ${icon}
    fi
}

# --- include custom plugins

source $HOME/.dotfiles/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.dotfiles/.zsh-plugins/mysql-import/mysql-import.zsh

# --- the end section
export STANDARD_PATH=$PATH
eval $_refresh_paths
