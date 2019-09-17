shopt -s histverify

if [ "$TERM" != 'dumb'  ]
then
    echo "bashrc version 0.9"
    export TERM=xterm #tmux workaround
fi

alias vpn="$(which sudo) grep 'Learn:\|connection-reset' /var/log/openvpn"

alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test1000.zip'

alias vnc='vncserver :1 -geometry 1600x900 -depth 24'

alias ipp='echo $(wget -qO- http://ipecho.net/plain)'

alias ix='curl -F "f:1=<-" ix.io'

alias last10='find . -type f -printf "%C+ %p\n" | sort -rn | head -n 10'

alias a='tmux a -t $1'

alias http='python3 -m http.server'

alias pw='head /dev/urandom | tr -dc A-Za-z0-9 | head -c20; echo'

alias dog='pygmentize -g' # https://stackoverflow.com/questions/7851134/syntax-highlighting-colorizing-cat/14799752#14799752

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

#https://stackoverflow.com/questions/5785549/able-to-push-to-all-git-remotes-with-the-one-command/18674313#18674313
git config --global alias.pushall '!git remote | xargs -L1 git push --all'

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

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

#alias grep='grep --color=F'
#alias fgrep='fgrep --color=tty'
#alias egrep='egrep --color=tty'

if ! uname -a | grep -q "lineageos"; then
	alias grep="grep --color=auto"	
	alias rm='rm -I --preserve-root' # do not delete / or prompt if deleting more than 3 files at a time
	
    # Parenting changing perms on / #
    alias chown='chown --preserve-root'
    alias chmod='chmod --preserve-root'
    alias chgrp='chgrp --preserve-root'
fi

if [ -f "$HOME/.aliases" ];
then
    source "$HOME/.aliases"
fi

# if [ -d "$HOME/bin" ] ; then
    # PATH="$HOME/bin:$PATH"
# fi

p(){
    ps aux | grep "$1"
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
        yaourt -Syu --aur
        updaterc
    fi
}

# https://gist.github.com/mcustiel/d3dd1f9a4f9a8965f98957348d92a9ad
ssh_init() {

	LINES=$(ps aux | grep ssh-agent | wc -l)
	PPKDIR=~/.ssh/keys
	PATTERN="\\.pub$"
	if [ "2" -gt $LINES ] ; then
		ssh-agent -s > ~/.ssh-env-vars
		. ~/.ssh-env-vars

		for key in $(ls $PPKDIR) ; do
			# Add only private keys to ssh-agent
			if [[ ! $key =~ $PATTERN ]]; then
				ssh-add $PPKDIR/$key
			fi
		done
	else
		. ~/.ssh-env-vars
	fi
}

git_init() {

	LINES=$(ps aux | grep ssh-agent | wc -l)
	GIT_KEY=~/.ssh/git
	if [ "2" -gt $LINES ] ; then
		ssh-agent -s > ~/.ssh-env-vars
		. ~/.ssh-env-vars
		ssh-add $GIT_KEY
	else
		. ~/.ssh-env-vars
	fi
}

update_pip(){
    if which pip2 &> /dev/null; then
        pip2 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs "$(which sudo)" pip2 install -U
    fi

    if which pip3 &> /dev/null; then
        pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs "$(which sudo)" pip3 install -U
    fi
}

updaterc() {
    if which curl &> /dev/null; then
        rm ~/.bashrc
        curl https://raw.githubusercontent.com/plutonic1/bashrc/master/.bashrc > ~/.bashrc
        . ~/.bashrc
    elif which wget &> /dev/null; then
        rm ~/.bashrc
        wget -O ~/.bashrc https://raw.githubusercontent.com/plutonic1/bashrc/master/.bashrc
        . ~/.bashrc
    else
        echo "no download tool found"
    fi
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

    for i in {5..1}
    do
        echo -e "$i"
        sleep 1
    done
    $(which sudo) reboot && exit
}

#p() {
#    $(which sudo) true
#	echo poweroff in ...
#
#   for i in {10..1}
#    do
#        echo -e "$i"
#        sleep 1
#    done
#    $(which sudo) poweroff && exit
#}

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

k() {
    if ! tmux ls | grep -q "copy"; then
        tmux new -s copy
    else
        tmux a -t copy
    fi
}

t4(){
    SESSION=2

    tmux has-session -t $SESSION &> /dev/null

    if [ $? -eq 0 ]; then
        tmux attach -t $SESSION
        exit 0;
    fi

    tmux new-session -d -s $SESSION
    tmux split-window -h -t $SESSION:0
    tmux split-window -h -t $SESSION:0
    tmux split-window -h -t $SESSION:0
    tmux select-layout -t $SESSION "a490,119x39,0,0[120x19,0,0{59x19,0,0,11,60x19,60,0,12},120x19,0,20{59x19,0,20,13,60x19,60,20,18}]"
    tmux attach -t $SESSION
}

t2(){
    SESSION=2

    tmux has-session -t $SESSION &> /dev/null

    if [ $? -eq 0 ]; then
        tmux attach -t $SESSION
        exit 0;
    fi

    tmux new-session -d -s $SESSION

    if [ "$1" == "v"  ]
    then
        tmux split-window -v -t $SESSION:0
    else
        tmux split-window -h -t $SESSION:0
    fi

    tmux attach -t $SESSION
}

transfer() {

    if [[ -d $1 ]]; then
        location="/tmp/$1.zip"
        basename="$(basename $1).zip"
        echo "basename: $basename"
        zip -r $location $1        
    elif [[ -f $1 ]]; then
        location=$1
        basename=$1
    else
        echo "$1 is not valid"
        exit 1
    fi

    address=$(curl -k --progress-bar --upload-file "$location" https://plutonic.tk:8123/$(basename $basename) | tee /dev/null)    
    address_direct=$(echo $address | sed -e "s/8123\//8123\/get\//g")
    
    echo $address_direct
    
    type xclip &> /dev/null    
    if [ $? -eq "0" ]; then
        echo $address_direct | xclip -selection Clipboard
    fi
    
    type termux-set-clipboard &> /dev/null    
    if [ $? -eq "0" ]; then
        termux-clipboard-set $address_direct
    fi
    
    echo -e ""
}
alias transfer=transfer

export VISUAL=nano
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
