# bash rename files with pattern
# echo `cat $file | sed -E 's/console.log\((.*)\);?//g'` > $file
# for i in *.min.js; do echo "$i"; done
# for i in *.jpg; do j=`echo $i | sed 's/_ph//g'`; mv "$i" "$j"; done

alias iossimulator="(cd /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/ && open -a iPhone\ Simulator.app)"
#-- android simulator

#--- displays the flash traces in the terminal (when running in the flash player debugger) 
alias flog="tail -f ~/Library/Preferences/Macromedia/Flash\\ Player/Logs/flashlog.txt"
#-Or maybe you prefer flashlog in a gui
alias trace='/Applications/Utilities/Console.app/Contents/MacOS/Console ~/Library/Preferences/Macromedia/Flash\ Player/Logs/flashlog.txt &'

#--- list all hidden files in the current folder
alias lh='ls -a | egrep "^\."'

function randpassw() 
{
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




#
# -------------- SVN
#

alias svnremovemissing='svn status | grep '^\!' | cut -c8- | while read f; do svn rm "$f"; done'
alias svnremovenotadded='svn status | grep '^\?' | cut -c8- | while read f; do rm -rf "$f"; done'
alias svna="svn add . --force"
alias svnrevertall='svn status | grep '^\[A-M-D-?]' | cut -c8- | while read f; do svn revert "$f"; done'

# copies files under svn wich have been modified into another directory
function svnsyncfolder(){

if [ $# -lt 1 ]; then
        echo "1 parameter excepted";
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
                mkdir $targetDir
        fi
        cp $f $target/$dir
done

}


#--------------- PATH VARIABLES
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/bin/mongo:/opt/subversion/bin:$PATH


#------------------ COLORS
PS1="[\[\033[36m\]\u\[\033[37m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]]$ "

# LESS man page colors -------------------------------------------------
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'                           
export LESS_TERMCAP_so=$'\E[01;44;33m'                                 
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# rename all the files which contain uppercase letters to lowercase in the current folder
function filestolower()
{
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


function tree()
{
	pwd
	ls -R | grep ":$" |   \
	sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'

}


function cdfinder()
{
cd "$(osascript -e 'tell application "Finder"' \
  -e 'set myname to POSIX path of (target of window 1 as alias)' \
  -e 'end tell' 2>/dev/null)"
}

alias l="ls -alFhG"

alias tolowercase="pbpaste | tr "[:upper:]" "[:lower:]" | pbcopy"
alias touppercase="pbpaste | tr "[:lower:]" "[:upper:]" | pbcopy"

#-Quick ip checkers
function myIp(){
	en0=`ipconfig getifaddr en0`
	en1=`ipconfig getifaddr en1`
	if [ -z "$en0" ]; then
		echo $en1;
	else
		echo $en0;
	fi 
}

#-Dont delete your files by accident
alias rm="rm -i"
