# bash rename files with pattern
# echo `cat $file | sed -E 's/console.log\((.*)\);?//g'` > $file
# for i in *.min.js; do echo "$i"; done
# for i in *.jpg; do j=`echo $i | sed 's/_ph//g'`; mv "$i" "$j"; done

if [ -f ~/.bash_work ]
then
    source ~/.bash_work
fi

export HISTCONTROL=ignoredups
export HISTSIZE=1000
export HISTFILESIZE=1000
export PROMPT_COMMAND='echo -ne "\033]0;$PWD\007"'

export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:~/bin:$PATH
#export PATH=/opt/subversion/bin:$PATH
# for svn 1.7.6, add /opt/subversion/bin to path
export NODE_PATH="/usr/local/lib/node_modules:${NODE_PATH}"

alias dodo="pmset sleepnow"
alias httpstatuscode="curl -w %{http_code} -s --output /dev/null $1"
alias updatebashprofile="curl https://gist.github.com/erwanjegouzo/5903670/raw > ~/.bash_profile && reload"
alias reload="source ~/.bash_profile"
alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"
alias sublime='open -a "Sublime Text 2"'
alias flushDNS="dscacheutil -flushcache"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete && find . -name 'Thumbs.db' -type f -ls -delete"
alias editvhost="sudo nano /etc/apache2/extra/httpd-vhosts.conf"

alias weather="curl -s 'http://rss.accuweather.com/rss/liveweather_rss.asp?metric=1&locCode=en|us|brooklyn-ny|11215' | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p'"
alias tolowercase="pbpaste | tr "[:upper:]" "[:lower:]" | pbcopy"
alias touppercase="pbpaste | tr "[:lower:]" "[:upper:]" | pbcopy"

alias phplog="tail -f /var/log/apache2/error_log"

alias rm="rm -i"
# only show dot files
alias lsh="ls -ld .??*"

alias iossimulator="(cd /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/ && open -a iPhone\ Simulator.app)"

# Displays the flash traces in the terminal (when running in the flash player debugger) 
alias flog="tail -f ~/Library/Preferences/Macromedia/Flash\\ Player/Logs/flashlog.txt"
# Or maybe you prefer flashlog in a gui
alias trace='/Applications/Utilities/Console.app/Contents/MacOS/Console ~/Library/Preferences/Macromedia/Flash\ Player/Logs/flashlog.txt &'

#Calculates the gzip compression of a file
function gzipsize(){
	echo $((`gzip -c $1 | wc -c`/1024))"KB"
}

# Find files and ignore directories
function ff(){
  find . -iname $1 | grep -v .svn | grep -v .sass-cache
}

# GIT
function gitexport(){
	mkdir -p "$1"
	git archive master | tar -x -C "$1"
}

# SVN
alias svnremovemissing='svn status | grep '^\!' | cut -c8- | while read f; do svn rm "$f"; done'
alias svnremovenotadded='svn status | grep '^\?' | cut -c8- | while read f; do rm -rf "$f"; done'
alias svna="svn add . --force"
alias svnrevertall='svn status | grep '^\[A-M-D-?]' | cut -c8- | while read f; do svn revert "$f"; done'


# tab completion for ssh hosts
if [ -f ~/.ssh/known_hosts ]; then
    complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
fi

# Tab complete for sudo
complete -cf sudo


# COLORS
PS1="[\[\033[36m\]\u\[\033[37m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]]$ "

# LESS man page colors
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

mkcd () {
    mkdir -p "$*"
    cd "$*"
}

function sshKeyGen(){

echo "What's the name of the Key (no spaced please) ? ";
read name;

echo "What's the email associated with it? ";
read email;

`ssh-keygen -t rsa -f ~/.ssh/id_rsa_$name -C "$email"`;
pbcopy < ~/.ssh/id_rsa_$name.pub;

echo "SSH Key copied in your clipboard";

}

# rename all the files which contain uppercase letters to lowercase in the current folder
function filestolower(){
  read -p "This will rename all the files and directories to lowercase in the current folder, continue? [y/n]: " letsdothis
  if [ "$letsdothis" = "y" ] || [ "$letsdothis" = "Y" ]; then
    for x in `ls`
      do
      skip=false
      if [ -d $x ]; then
	read -p "'$x' is a folder, rename it? [y/n]: " renamedir
	if [ "$renamedir" = "n" ] || [ "$renameDir" = "N" ]; then
	  skip=true
	fi
      fi
      if [ "$skip" == "false" ]; then
        lc=`echo $x  | tr '[A-Z]' '[a-z]'`
        if [ $lc != $x ]; then
          echo "renaming $x -> $lc"
          mv $x $lc
        fi
      fi
    done
  fi
}

# Copies files under svn wich have been modified into another directory
function svnsyncfolder(){
if [ $# -lt 1 ]; then
        echo "1st paramater has to be the location where you want to export the changes";
        return 0;
fi
target=$1;
if [ ! -d $target ]; then
        echo "The target directory doesn't exist, create it? [y/n]: "
        read createDir
        if [ $createDir == "y" ]; then
                mkdir $target
        fi
fi
svn status | grep '^[A-M]' | cut -c8- | while read f; do
        echo "=> $f";
        dir=`dirname $f`
        targetDir=$target/$dir
        if [ ! -d $targetDir ];then
                mkdir -p $targetDir
        fi
        cp $f $target/$dir
done
}

function tree(){
	pwd
	ls -R | grep ":$" |   \
	sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
}


function cdfinder(){
cd "$(osascript -e 'tell application "Finder"' \
  -e 'set myname to POSIX path of (target of window 1 as alias)' \
  -e 'end tell' 2>/dev/null)"
}


function randpassw() {
	if [ -z $1 ]; then
		MAXSIZE=10
	else
		MAXSIZE=$1
	fi
	array1=( 
	q w e r t y u i o p a s d f g h j k l z x c v b n m Q W E R T Y U I O P A S D 
	F G H J K L Z X C V B N M 1 2 3 4 5 6 7 8 9 0 
	\! \@ \$ \% \^ \& \* \! \@ \$ \% \^ \& \* \@ \$ \% \^ \& \* 
	) 
	MODNUM=${#array1[*]} 
	pwd_len=0 
	while [ $pwd_len -lt $MAXSIZE ] 
	do 
	    index=$(($RANDOM%$MODNUM)) 
	    echo -n "${array1[$index]}" 
	    ((pwd_len++)) 
	done 
	echo 
}
