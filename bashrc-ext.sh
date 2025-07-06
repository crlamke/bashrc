#!/usr/bin/bash
#Project Home: https://github.com/crlamke/bashrc
#Copyright   : 2025 Christopher R Lamke
#License     : MIT - See https://opensource.org/licenses/MIT
#Purpose     : This file is intended to be sourced by the user's .bashrc

. ~/bin/bashrc/prompts.sh

# Start with "more" as default pager, but use "less" if available.
pager="more"
if command -v less > /dev/null 2>&1; then
  pager="less"
fi

# Set up aliases
alias new="ls -larth"
alias mew="ls -larth"
alias old="ls -lath"
alias h="history 100 | sort -rn | less"
alias bashreload="source ~/.bashrc && echo bash config reloaded"
alias sudo="sudo "
alias rm='rm -v'

# Internal use functions and variables
resultDest="/tmp"
cores=$(getconf _NPROCESSORS_ONLN)
NL=$'\n'
TAB=$'\t'
REDTEXT="\033[31;1m"
BLUETEXT="\033[34;1m"
GREENTEXT="\033[32;1m"
YELLOWTEXT="\033[33;1m"
COLOREND="\033[0m"


function diskspace()
{
  printf "%s\n" "***Disk Space***"
  printf "%s" "% Used${TAB}Size${TAB}Mounted On${TAB}${TAB}Filesystem${NL}"
  IFS=" "
  while read -r fileSystem size used avail percentUsed mountedOn
  do
    usedInt=$(sed 's/%//' <<< $percentUsed)
    #usedInt=$(($usedInt + 60)) # Used to test logic below and color printing
    if [[ $usedInt -ge 90 ]]; then 
      textColor=$REDTEXT
    elif [[ $usedInt -ge 70 ]]; then 
      textColor=$YELLOWTEXT
    else
      textColor=$GREENTEXT
    fi
    printf "%b%s%b%s\n" "$textColor" "${percentUsed}" "$COLOREND" "${TAB}${size}${TAB}${fileSystem}${TAB}${TAB}${mountedOn}" 
  done <<< $(df -khP | sed '1d')
}

function sfind()
{
  if [[ $# -eq 2 ]]; then
    searchResultsFile="$resultDest/sfind-results-$(date +"%Y%m%d-%H%M%S%Z")"
    printf "Searching file system starting at $1 for filenames matching \"$2\" pattern ...\n\n"
    printf "*** BEGIN results of file system search starting at \"$1\" for filename matching  \"$2\" pattern ***\n" > $searchResultsFile
    find $1 -iname "$2" 2>/dev/null >> $searchResultsFile
    #find $1 -iname "$2" 2>/dev/null | tee -a $searchResultsFile
    printf "*** END results of file system search starting at \"$1\" for filename matching  \"$2\" pattern ***\n" >> $searchResultsFile
    cat $searchResultsFile
    printf "\nSearch results were written to $searchResultsFile\n"
  else
    printf "Usage: sfind search-path-root file-name-pattern\n"
    printf "Ex: sfind ~/dev config.xml\n"
  fi
}

function hfind() 
{
  if [[ $# -eq 1 ]]; then
    searchResultsFile="$resultDest/hfind-results-$(date +"%Y%m%d-%H%M%S%Z")"
    printf "Searching command history for \"$1\" ...\n\n"
    printf "*** BEGIN results of command history search for \"$1\" ***\n" > $searchResultsFile
    history | grep "$1" 2>/dev/null >> $searchResultsFile
    printf "*** END results of command history search for \"$1\" ***\n" >> $searchResultsFile
    cat $searchResultsFile
    printf "\nResults above written to $searchResultsFile\n"
  else
    printf "Usage: hfind \"search-string\"\n"
    printf "Ex: hfind yum\n"
  fi
}

function back() 
{
  if [[ $# -eq 1 ]]; then
    if [ -f $1 ]; then
      backupDTG=$(date +"%Y%m%d-%H%M%S%Z")
      backupName="$1.bak.$backupDTG"  
      echo "Copying $1 to $backupName"
      cp $1 $backupName
      echo "Done"
    else
      printf "$1 not found\n"
    fi
  else
    printf "Usage: back file-name\n"
    printf "Ex: back startup.cfg\n"
  fi
}

function sysload() 
{
  cores=$(getconf _NPROCESSORS_ONLN)
  oneMinuteLoad=$(cat /proc/loadavg | awk -v c=$cores '{print $1 * 100 / c}')
  fiveMinuteLoad=$(cat /proc/loadavg | awk -v c=$cores '{print $2 * 100 / c}')
  fifteenMinuteLoad=$(cat /proc/loadavg | awk -v c=$cores '{print $3 * 100 / c}')
  memAvailable=$(grep 'MemAvailable:' /proc/meminfo | \
               awk '{print int($2 / 1024)}')
  memTotal=$(grep 'MemTotal:' /proc/meminfo | \
               awk '{print int($2 / 1024)}')
  memPercentFree=$((${memAvailable} * 100 / ${memTotal}))
  printf "60 Sec\t5 Min\t15 Min\tFree RAM  Total RAM\n"
  printf " %s%%\t %s%%\t %s%%\t  %s%%      %sMB\n" \
         $oneMinuteLoad $fiveMinuteLoad $fifteenMinuteLoad $memPercentFree $memTotal
}


#
# Set history config
#
export HISTTIMEFORMAT='%F %T: '
shopt -s histappend

# export HISTCONTROL=ignoredups // Uncomment to have history ignore duplicates

# Uncomment the following line if you don't like systemctl's auto-paging feature
# export SYSTEMD_PAGER=

#Define less terminal capabilities so less and man pages are easier to read.
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export JAVA_HOME=/usr

export EDITOR="/usr/bin/vim"

PATH="~:$PATH"
