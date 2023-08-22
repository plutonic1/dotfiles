shopt -s histverify

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# https://unix.stackexchange.com/a/265649
export HISTCONTROL=ignoreboth:erasedups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

alias speedtest='wget -O /dev/null https://speed.hetzner.de/100MB.bin'

alias vnc='vncserver :1 -geometry 1600x900 -depth 24'

alias ipp='echo $(wget -qO- http://ipecho.net/plain)'

alias ix='curl -F "f:1=<-" ix.io'

alias last10='find . -type f -printf "%C+ %p\n" | sort -rn | head -n 10'

alias a='tmux a -t $1'

alias http='python3 -m http.server'

alias pw='head /dev/urandom | tr -dc A-Za-z0-9 | head -c20; echo'

alias dog='pygmentize -g' # https://stackoverflow.com/questions/7851134/syntax-highlighting-colorizing-cat/14799752#14799752

alias n='$(which sudo) netstat -tulpen'

#let ssh use the gpg-agent for auth
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

#taken from http://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html

#alias mount='mount | column -t'

# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

alias ls='ls --color'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'
alias last='last -i'

# http://superuser.com/questions/137438/how-to-unlimited-bash-shell-history
# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

if ! uname -a | grep -q "lineageos"; then
	alias grep="grep --color=auto"	
	alias rm='rm -I --preserve-root' # do not delete / or prompt if deleting more than 3 files at a time
	
    # Parenting changing perms on / #
    alias chown='chown --preserve-root'
    alias chmod='chmod --preserve-root'
    alias chgrp='chgrp --preserve-root'
fi

# for unsing my Yubikey with WSL
if uname -a | grep -qi "microsoft"; then
	export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
	ss -a | grep -q $SSH_AUTH_SOCK
	if [ $? -ne 0 ]; then
			rm -f $SSH_AUTH_SOCK
			(setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:/mnt/c/Users/plutonic/Desktop/Tausch/Tools/wsl2-ssh-pageant.exe >/dev/null 2>&1 &)
	fi
fi

# restart gpg-agent on error
if uname -a | grep -qi "linux"; then
  gpg --card-status &> /dev/null || {
    gpg-connect-agent updatestartuptty /bye
  }
fi

if [ -f "$HOME/.aliases" ];
then
    source "$HOME/.aliases"
fi

p(){
    ps aux | grep "$1" | grep -v
}

h(){
    history | grep "$1"
}

s(){
    if which pkg &> /dev/null; then
        pkg search "$1"
    elif which apt-cache &> /dev/null; then
        apt-cache search "$1"
    elif which pacman &> /dev/null; then
        pacman -Ss "$1"
    fi
}

i(){
    if which pkg &> /dev/null; then
        pkg install "$@"
    elif which apt-get &> /dev/null; then
        $(which sudo) apt-get install "$@"
    elif which pacman &> /dev/null; then
        $(which sudo) pacman -S "$@"
    fi
}

u() {

    if uname -a | grep -q "lineageos"; then
        export HISTSIZE=100000000000000000 #termux workaround
    fi
        
    if which pkg &> /dev/null; then
        pkg upgrade
        updaterc
    elif which apt-get &> /dev/null; then     
        $(which sudo) apt-get update -y
        $(which sudo) apt-get upgrade -y
        $(which sudo) apt-get clean
        $(which sudo) apt-get autoremove
        updaterc
    elif which apt-cyg &> /dev/null; then
        apt-cyg update
        updaterc
    elif which pacman &> /dev/null; then
        yay -Syu
        updaterc
    fi
}

updaterc() {
    git -C ~/.dotfiles pull || git clone https://github.com/plutonic1/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && stow -t ~ */
}

#https://stackoverflow.com/questions/4643438/how-to-search-contents-of-multiple-pdf-files/4643518#4643518
pdfsearch() {
    cmd="find . -name '*.pdf' -exec sh -c 'pdftotext \"{}\" - | grep --with-filename --label=\"{}\" --color \"$1\"' \;"
    eval "$cmd"
}

key() {
    gpg --keyserver pgpkeys.mit.edu --recv-key "$1"
}

r() {
	$(which sudo) true
    echo reboot in ...

    for i in {10..1}
    do
        echo -e "$i"
        sleep 1
    done
    $(which sudo) reboot && exit
}

fixlocale() {
    sudo locale-gen de_DE.UTF-8
    sudo update-locale LANG=de_DE.UTF-8
}

extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xvjf "$1"    ;;
            *.tar.gz)    tar xvzf "$1"    ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x -kb "$1" ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xvf "$1"     ;;
            *.tbz2)      tar xvjf "$1"    ;;
            *.tgz)       tar xvzf "$1"    ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *.xz)        tar --xz -xvf "$1";;

            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

wsl_docker(){
	DOCKER_DISTRO="Ubuntu-20.04"
	DOCKER_DIR=/mnt/wsl/shared-docker
	DOCKER_SOCK="$DOCKER_DIR/docker.sock"
	export DOCKER_HOST="unix://$DOCKER_SOCK"
	if [ ! -S "$DOCKER_SOCK" ]; then
		mkdir -pm o=,ug=rwx "$DOCKER_DIR"
		chgrp docker "$DOCKER_DIR"
		/mnt/c/Windows/System32/wsl.exe -d $DOCKER_DISTRO sh -c "nohup sudo -b dockerd < /dev/null > $DOCKER_DIR/dockerd.log 2>&1"
	fi
}

yt(){
  d=$(mktemp)
  $VISUAL $d
  yt-dlp -a $d
}


export VISUAL=vim
export LANG=de_DE.UTF-8

#LS_COLORS='di=36:ln=32:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43':
#export LS_COLORS

# colored manpages
export PAGER=less
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

Decoration1="\[\e[90m\]╔["
DatePart="\[\e[39m\]\d \t "
RegularUserPart="\[\e[36m\]\u"
RootUserPart="\[\e[31;1m\]\u\[\e[m\]"
Between="\[\e[37m\]@"
HostPart="\[\e[92m\]\h:"
PathPart="\[\e[93;1m\]\w"
Decoration2="\[\e[90m\]]\n╚>\[\e[m\]"

case $(id -u) in
    0) export PS1="$Decoration1$DatePart$RootUserPart$Between$HostPart$PathPart$Decoration2# ";;
    *) export PS1="$Decoration1$DatePart$RegularUserPart$Between$HostPart$PathPart$Decoration2$ ";;
esac
