# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM=$HOME/.dotfiles/.zsh-plugins

# Set name of the theme to load.
ZSH_THEME="ys"
if [[ -r "$HOME/.oh-my-zsh/themes/ys-custom.zsh-theme" ]]; then
    ZSH_THEME="ys-custom"
fi

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

MAGIC_ENTER_GIT_COMMAND="gst"

# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git wp-cli z colored-man-pages nmap command-not-found nmap httpie magic-enter)

# --- User configuration

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim'

export PATH="$HOME/.bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:$HOME/.local/bin"
if [[ -r "$HOME/.zprofile" ]]; then
    source "$HOME/.zprofile"
fi

if [ -f "$HOME/.cargo/env" ] ; then
    source "$HOME/.cargo/env"
fi

# have NPM install global packages in the home dir
export NPM_PACKAGES="${HOME}/.npm-packages"
export NPM_CONFIG_PREFIX=~/.npm-packages
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
PATH="$NPM_PACKAGES/bin:$PATH"
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

type nc > /dev/null && nc -w1 -z localhost 4873 && export NPM_CONFIG_REGISTRY=http://localhost:4873

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# --- Aliases

alias git-ls='git ls-tree -r $(git rev-parse --abbrev-ref HEAD) --name-only'
alias find='noglob find'

parent-find() {
  local file="$1"
  local dir="${2:-$(pwd)}"

  while [[ "$dir" != "/" ]]; do
    if [[ -e "$dir/$file" ]]; then
      echo "$dir/$file"
      return 0
    fi
    dir="$(dirname "$dir")"
  done

  # Check the root directory as a last resort
  if [[ -e "/$file" ]]; then
    echo "/$file"
    return 0
  fi

  return 1
}

alias €='noglob €'
alias €€='noglob €€'

alias csv='column -n -s , -t'
type yq > /dev/null && alias yq='yq -C'

alias qr='qrencode -t utf8 -m2'

# output everything before a string (not included)
before() {
	grep -i -B10000 "$@" | head -n -1
}

# output everything adter a string (not included)
after() {
	grep -i -A10000 "$@" | tail -n +2
}

# remove empty lines
alias filter-empty='grep -vP '\''^'\\'s*$'\'

# trim leading and trailing whitespaces
alias trim='sed "s/\(^ *\| *\$\)//g"'

alias sum-of='xargs | sed -e "s/\\ /+/g" | bc'

alias x='xdg-open'

alias add-alias='echo "Please insert the new alias:"; read string; echo alias ${string} >> $HOME/.aliases; source $HOME/.aliases'
alias edit-alias='$EDITOR $HOME/.aliases; source $HOME/.aliases'

# please add custom aliases in the file below insted
source $HOME/.aliases
test -f $HOME/.custom-aliases || touch $HOME/.custom-aliases
source $HOME/.custom-aliases

[[ -f ~/.bin/git-links ]] && INTERPOLATE_GIT_LOG=1 source ~/.bin/git-links

byobu_col () {
    #!/bin/sh -e
    #
    #    col1..col9 - handy hack to print a column from standard in
    #
    #    Copyright (C) 2010 Dustin Kirkland <kirkland@ubuntu.com>
    #
    #    Authors:
    #        Dustin Kirkland <kirkland@ubuntu.com>
    #
    #    This program is free software: you can redistribute it and/or modify
    #    it under the terms of the GNU General Public License as published by
    #    the Free Software Foundation, either version 3 of the License.
    #
    #    This program is distributed in the hope that it will be useful,
    #    but WITHOUT ANY WARRANTY; without even the implied warranty of
    #    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    #    GNU General Public License for more details.
    #
    #    You should have received a copy of the GNU General Public License
    #    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    b=$1
    shift || true

    if [ $# -gt 0 ]; then
        ifs='-F'"$1"
        shift || true
    else
        ifs="-F "
    fi

    awk "$ifs" '{print $'${b#col}'}' ${@:1}
}

col1 () {
    byobu_col 1 "$@"
}
col2 () {
    byobu_col 2 "$@"
}
col3 () {
    byobu_col 3 "$@"
}
col4 () {
    byobu_col 4 "$@"
}
col5 () {
    byobu_col 5 "$@"
}
col6 () {
    byobu_col 6 "$@"
}
col7 () {
    byobu_col 7 "$@"
}
col8 () {
    byobu_col 8 "$@"
}
col9 () {
    byobu_col 9 "$@"
}
NF () {
    byobu_col NF "$@"
}





# --- output highlighting for common commands

alias sudo='sudo '
[[ -s "/etc/grc.conf" ]] && source $HOME/.dotfiles/.zsh-plugins/grc/grc.zsh
type "docker-machine" > /dev/null && source $HOME/.dotfiles/.zsh-plugins/docker-machine-completion/docker-machine-completion.zsh
# combine grc with native coloring and make ls output clickable hyperlinks
[[ -s "/etc/grc.conf" ]] && alias ll='grc --colour=auto ls -lh --color=always --hyperlink=always'
alias dmesg='dmesg --reltime --color'
type "code-insiders" > /dev/null && alias code=code-insiders
type "fuck" > /dev/null && eval $(thefuck --alias)

# --- autocomplete npm packages

type "all-the-package-names" > /dev/null && source $HOME/.dotfiles/.zsh-plugins/zsh-better-npm-completion/zsh-better-npm-completion.plugin.zsh

# --- autocomplete kill

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# --- docker-compose / docker exec aliases

function Ð() {
    if [[ $# -eq 0 ]]; then
        docker-compose ps
    else
        local line_number=`expr 2 + $1`
        # we pipe echo to avoid docker-compose detecting the width of the terminal
        # because it would wrap long lines making tail | head ineffective
        local machine_name=`echo '' | docker-compose ps | tail -n+$line_number | head -n1 | cut -f1 -d ' '`
        [[ -z $2 ]] && 2=bash
        docker exec -it $machine_name ${@:2}
    fi
}

alias Ð1='Ð 1'
alias Ð2='Ð 2'
alias Ð3='Ð 3'
alias Ð4='Ð 4'
alias Ð5='Ð 5'
alias Ð6='Ð 6'
alias Ð7='Ð 7'
alias Ð8='Ð 8'
alias Ð9='Ð 9'
alias Ð10='Ð 10'

# --- pretty print yml and json

alias -g @yml='| yq eval -P'
alias -g @json='| jq'

alias package-json='echo; cat $(parent-find package.json) | yq eval -P'

# --- easy xargs
alias -g »='| xargs -n1 -d "\n"'
alias -g »»='| xargs -n1 -I{} -d "\n"'

# --- easy grep (altgr + shift + s)
alias -g §=' | grep -i '

alias docker-list-dangling-images='docker images -f dangling=true'
alias docker-remove-dangling-images='docker rmi $(docker images -q -f dangling=true)'
alias docker-list-stopped-containers='docker ps -a -f status=exited'
alias docker-remove-stopped-containers='docker rm $(docker ps -a -q -f status=exited)'
alias docker-list-dangling-volumes='docker volume ls -f dangling=true'
alias docker-remove-dangling-volumes='docker volume rm $(docker volume ls -q -f dangling=true)'

git_http_to_ssh(){
   echo $1 | sed 's#^https://#git@#g' | sed -E 's#(^git@[^/]+)/(.*)#\1:\2#g'
}

# --- Paths

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

# --- Utility functions

# --- Shortcuts

# --- Use "+"" to pick and autocompleted item without closing
#     the completions menu
bindkey -M menuselect "+" accept-and-menu-complete

export _SEP='';
multiline () {
[ $_SEP ] && _SEP='' || _SEP='\\\n  ';
[ $_SEP ] && echo 'multiline on' || echo 'multiline off';
_bind_custom_keys;
}

custom_nnn() {
    local TMP_FILE=$(mktemp /tmp/nnn-lastd.XXXXXX)
    NNN_TMPFILE=$TMP_FILE \nnn "$@"
    local DEST_FOLDER=$(cat $TMP_FILE | head -n1)
    rm $TMP_FILE
    # this check is insuficient, the following eval may lead to disasters
    echo "$DEST_FOLDER" | grep -P '^cd ' > /dev/null || (echo invalid syntax; exit 255)
    eval "$DEST_FOLDER";
}

alias nnn='custom_nnn'

timestamp() {
    date +%Y%m%d%H%M%S
}

_bind_custom_keys () {
    # --- base commands (just typing, no execution) ---

    # --- Alt + l|L to write git log and git log --all
    bindkey -s '\el' 'glol\n'
    bindkey -s '\eL' 'glola\n'
    # --- Alt + s to pipe in grep
    bindkey -s '\eg' $_SEP' | grep -i '
    # --- Alt + x/X to pipe in xargs
    bindkey -s '\ex' $_SEP' | xargs -n1 -d "\\n" '
    bindkey -s '\eX' $_SEP' | xargs -n1 -d "\\n" -I {} '
    # --- Alt + f to find -name
    bindkey -s '\ef' 'find . -name *'
    # --- Alt + s to sed -s s///g
    bindkey -s '\es' $_SEP' | sed -s '\''s///g'\'
    # --- Alt + t to print timestamp
    bindkey -s '\et' '$(timestamp)'
    # --- Alt + c to count with wc -l
    bindkey -s '\ec' $_SEP' | wc -l'
    # --- Alt + o to git checkout
    bindkey -s '\eo' 'git checkout '
    # --- Alt + u to sort -u
    bindkey -s '\eu' $_SEP' | sort -u'
    # --- Alt + y to @yml
    bindkey -s '\ey' $_SEP' @yml'
    # --- Alt + j to @json
    bindkey -s '\ej' $_SEP' @json'
    # --- Alt + e to nnnn
    bindkey -s '\ee' $_SEP'nnn -cH\n'
    # --- Alt + Shift + y to yarn run
    bindkey -s '\eY' $_SEP'yarn run '


    # --- instant commands (will execute immediately) ---

    # --- Alt + d to git diff
    bindkey -s '\ed' "git diff\n"
    # --- Alt + D to git diff --cached
    bindkey -s '\eD' "git diff --cached\n"
    # --- Alt + . to cd ..
    bindkey -s '\e.' "cd ..\n"

    # --- misc ---

    # --- Ctrl + Backspace will delete a word (tilix does not do that natively)
    bindkey "^H" backward-kill-word

}
_bind_custom_keys;

# --- Alt + H to access the man page of the current command
# (ex: git commit<Esc+h>)
autoload run-help

# Alt+S to insert sudo at the beginning of the line

insert_sudo () {
    local prefix="sudo"
    BUFFER="$prefix $BUFFER"
    CURSOR=$(($CURSOR + $#prefix + 1))
}
zle -N insert-sudo insert_sudo
bindkey "^[S" insert-sudo

# Alt + w to insert watch at the beginning of the line

insert_watch () {
    local prefix="  watch -n0.5 -p -c grc --colour=on"
    BUFFER="$prefix $BUFFER"
    CURSOR=$(($CURSOR + $#prefix + 1))
    zle accept-line
}
zle -N insert-watch insert_watch
bindkey "^[w" "insert-watch"

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

function find-port() {
    if [[ -s "/etc/grc.conf" ]]; then
        local highlight=(grc -c conf.lsof cat -)
    else
        local highlight=(cat -)
    fi
    local output=$(sudo lsof -n -i :${1})
    echo "$output" | head -n1 1>&2
    echo "$output" | grep LISTEN | $highlight
}

function kill-port() {
    find-port $1 2> /dev/null | awk '{print $2}' | xargs sudo kill ${@:2}
}

function gh() {
    git clone git@github.com:${1}.git ${@:2}
}

function gitignore.io() {
	curl -L -s https://www.gitignore.io/api/$@ ;
}

function git-make-date() {
    LC_ALL=C git log --all | grep -i "Date:   " | tail +2 | head -1 | sed -s 's/Date://g' | sed -s 's/+0200/CEST/g' | sed "s/\(^ *\| *\$\)//g" | LC_ALL=C xargs -n1 -d "\n" -I {} date -d'{} +'$(shuf -i 12-40 -n 1)' minutes'
}

function git-change-date() {
    local new_date=$(git-make-date)

    LC_ALL=C GIT_COMMITTER_DATE="$new_date" git commit --amend --date "$new_date"
}

function filewatch() {
    # TODO: kill process upon repeat
    # TODO: optional notify-send
    local time=${FILEWATCH_SLEEP_TIME:-0}
    echo "${@:2}"
   "${@:2}"
   while inotifywait -r -e close_write ${~1}; do sleep $time; ${@:2}; done;
}

alias filewatch='noglob filewatch'
alias filewatch0='FILEWATCH_SLEEP_TIME=0.5 noglob filewatch'
alias filewatch1='FILEWATCH_SLEEP_TIME=1 noglob filewatch'
alias filewatch2='FILEWATCH_SLEEP_TIME=2 noglob filewatch'
alias filewatch3='FILEWATCH_SLEEP_TIME=3 noglob filewatch'
alias filewatch4='FILEWATCH_SLEEP_TIME=4 noglob filewatch'
alias filewatch5='FILEWATCH_SLEEP_TIME=5 noglob filewatch'
alias filewatch6='FILEWATCH_SLEEP_TIME=6 noglob filewatch'
alias filewatch7='FILEWATCH_SLEEP_TIME=7 noglob filewatch'
alias filewatch8='FILEWATCH_SLEEP_TIME=8 noglob filewatch'
alias filewatch9='FILEWATCH_SLEEP_TIME=9 noglob filewatch'
alias filewatch10='FILEWATCH_SLEEP_TIME=10 noglob filewatch'


function filewatch2() {
    # TODO: kill process upon repeat
    # TODO: optional notify-send
   "${@:2}" &
   PID=$!
   echo "$PID - ${@:2}"
   while inotifywait -e close_write ${~1}; do
       kill $PID
       wait $PID
       ${@:2};
   done;
   kill $PID
   wait $PID
}


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
    local icon=😎
    local _status

    if [[ ${_tr_error} != 0 ]] ; then
      icon='🔴'
      _status=" [status: ${_tr_error}]";
    fi


    te=$((${SECONDS}-${_tr_sec_begin}))
    if [[ "x${_tr_ignored}" = "x" && $te -gt $TIME_REPORT_THRESHOLD ]] ; then
        _tr_ignored="yes"
        echo "\n${icon} \`${_tr_current_cmd}\` completed in ${te} seconds."
	if type notify-send > /dev/null; then
        	notify-send "${icon} \`${_tr_current_cmd}\` completed in <b>${te}</b> seconds.${_status}"
	fi
    fi
}

# --- include custom plugins

source $HOME/.dotfiles/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.dotfiles/.zsh-plugins/mysql-import/mysql-import.zsh

autoload -U compaudit compinit

# --- the end section
export STANDARD_PATH=$PATH
eval $_refresh_paths

# --- fix tilix
# if [ -f /etc/profile.d/vte-2.91.sh ]; then
#     source /etc/profile.d/vte-2.91.sh
# fi

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        if [ -f /etc/profile.d/vte.sh ]; then
            source /etc/profile.d/vte.sh
        elif [ -f /etc/profile.d/vte-2.90.sh ]; then
            source /etc/profile.d/vte-2.90.sh
        fi
fi

# --- Command not found handler

# # Manjaro: offer to install missing package if command is not found
# if [[ -r /usr/share/zsh/functions/command-not-found.zsh ]]; then
    # source /usr/share/zsh/functions/command-not-found.zsh
command_not_found_handler() {
    local pkgs cmd="$1"

    pkgs=(${(f)"$(pkgfile -b -v -- "$cmd" 2>/dev/null)"})
    if [[ -n "$pkgs" ]]; then
        printf 'The application %s is not installed. It may be found in the following packages:\n' "$cmd"
        printf '  %s\n' $pkgs[@]
        setopt shwordsplit
        pkg_array=($pkgs[@])
        pkgname="${${(@s:/:)pkg_array}[2]}"
        printf 'Do you want to Install package %s? (y/N) ' $pkgname
        if read -q "choice? "; then
                echo
                echo "Executing command: pamac install --no-upgrade $pkgname"
                pamac install --no-upgrade $pkgname
        else
                echo " "
        fi
    else
        printf 'zsh: command not found: %s\n' "$cmd"
    fi 1>&2

    return 127
}
export PKGFILE_PROMPT_INSTALL_MISSING=1
# fi
# /--- Command not found handler

export PATH=./scripts:/home/stefano/.local/bin:$PATH

# --- options override

unsetopt completealiases # enables alias completion

# start the terminal with matrix rain
if  [[ "$TERM_PROGRAM" != "vscode" ]]; then
    if type neo-matrix > /dev/null; then
        local matrix_colors=("green" "green2" "green3" "green" "green2" "green3" "yellow" "orange" "red" "cyan" "pink" "pink2")
        local matrix_selected_color=${matrix_colors[ 1 + $RANDOM % ${#matrix_colors[@]} ]}
        local matrix_message=$(type fortune > /dev/null && fortune || echo '' -n)
        neo-matrix -D -s -M 1 -m "$matrix_message" --color $matrix_selected_color || true
    elif type cmatrix > /dev/null; then
        cmatrix -s; read -k1 -s || true
    fi
fi

