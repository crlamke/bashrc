# .bashrc
#set -x

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Set up aliases
alias new="ls -larth"
alias mew="ls -larth"
alias old="ls -lath"
alias h="history 100 | sort -rn | more"
alias bashreload="source ~/.bashrc && echo bash config reloaded"
alias sudo="sudo "
alias df="df -Tha --total"
alias rm='rm -v' # Used to be rm -iv but that was too annoying

# Internal use functions and variables
cores=$(getconf _NPROCESSORS_ONLN)

function disk-space-check()
{
  #fsExclusionList="^Filesystem|^cdrom|^cgroup|^proc|^fusectl|^sunrpc|^securityfs|^pstore|^sys"
  df -H | grep -vE "^Filesystem|^cdrom|^cgroup|^proc|^fusectl|^sunrpc|^securityfs|^pstore|^sys}" \
    | awk '{ print $1 "\t\t"  $6 "\t "  $7 }'
}

function sys-load-check()
{
  oneMinuteLoad=$(cat /proc/loadavg | awk -v c=$cores '{print $1 * 100 / c}')
  fiveMinuteLoad=$(cat /proc/loadavg | awk -v c=$cores '{print $2 * 100 / c}')
  fifteenMinuteLoad=$(cat /proc/loadavg | awk -v c=$cores '{print $3 * 100 / c}')
}

function mem-load-check()
{
  memAvailable=$(grep 'MemAvailable:' /proc/meminfo | \
               awk '{print int($2 / 1024)}')
  memTotal=$(grep 'MemTotal:' /proc/meminfo | \
               awk '{print int($2 / 1024)}')
  memPercentFree=$((${memAvailable} * 100 / ${memTotal}))
}

# Set up functions
function back() 
{
    echo "Copying $1 to $1.bak"
    cp $1 $1.bak
    echo "Done"
}

function find-list() 
{
  if [[ $# -eq 2 ]]; then
    LC_ALL=C find $1 -type f -name "$2" -exec ls -la {} + 2> /dev/null
  else
    printf "Usage: find-list starting-directory \"search-pattern\"\n"
    printf "Ex: find-list ~/ \"*.cfg\"\n"
  fi
}

function find-do() 
{
  if [[ $# -eq 3 ]]; then
    LC_ALL=C find $1 -type f -name "$2" -exec $3 {} + 2> /dev/null
  else
    printf "Usage: find-do starting-directory \"search-pattern\" command-to-run-on-match\n"
    printf "Ex: find-do ~/ \"*.cfg\" ls \n"
  fi
}


function sys-load() 
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
  printf "60 Sec\t5 Min\t15 Min\tFree RAM\t\n"
  printf " %s%%\t %s%%\t %s%%\t  %s%%\n" \
         $oneMinuteLoad $fiveMinuteLoad $fifteenMinuteLoad $memPercentFree
}

function sys-load2() 
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
  printf "Sys Load:  60 Sec-%s%%  5 Min-%s%%  15 Min-%s%%\n" \
         $oneMinuteLoad $fiveMinuteLoad $fifteenMinuteLoad
  printf "RAM:  Avail-%sMB  Total-%sMB  Free-%d%%\n" \
         "${memAvailable}"  "${memTotal}"  "${memPercentFree}"

}

function sys-health() 
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
  printf "Sys Load:  60 Sec-%s%%  5 Min-%s%%  15 Min-%s%%\n" \
         $oneMinuteLoad $fiveMinuteLoad $fifteenMinuteLoad
  printf "RAM:  Avail-%sMB  Total-%sMB  Free-%d%%\n" \
         "${memAvailable}"  "${memTotal}"  "${memPercentFree}"
}

function cycle-prompt() 
{
  export PS1="\n\[\033[0;34m\]\u@\h \D{%F %T}\[\033[0m\]\n\[\033[0;32m\][\$?] \w\[\033[0m\] \n[\!]->"
}

function help()
{
  printf "\n***** .bashrc help *****\n" 
  printf "Functions\n" 
  printf "  back FILE - back up file to file.bak\n" 
  printf "  find-list PATH \"SEARCH-PATTERN\" - find files and print path and stats\n" 
  printf "  find-do PATH \"SEARCH-PATTERN\" \"COMMAND\" - find files and print path and stats\n" 
  printf "  sys-load - Short and quick snapshot of system load\n" 
  printf "  sys-load2 - Slightly more detailed snapshot of system load\n" 
  printf "  sys-health - Snapshot of system health\n" 
  printf "  cycle-prompt - cycle through available system prompts\n" 
  printf "  help - This function\n" 
  printf "Aliases\n" 
  printf "  new = ls -larth\n" 
  printf "  old = ls -lath\n" 
  printf "  mew = ls -larth\n" 
  printf "  h = history 100 | sort -rn | more\n" 
  printf "  sudo = \"sudo \"\n" 
  printf "  bashreload = source ~/.bashrc && echo bash config reloaded\n" 
  printf "  df = df -Tha --total\n" 
  printf "  rm = rm -v #Used to be rm -iv but that was too annoying \n" 
}


# Set up prompts
#Simple PS1 prompt with some color
PS1="\[\e[36;1m\]\h:\[\e[32;1m\]\w$ \[\e[0m\]"
# More complex, multi-line colored prompt
#PS1="\n\[\033[0;34m\]\u@\h \D{%F %T}\[\033[0m\]\n\[\033[0;32m\][\$?] \w\[\033[0m\] \n[\!]->"

#
# Set history config
#
export HISTTIMEFORMAT='%F %T: '
shopt -s histappend

# export HISTCONTROL=ignoredups // Uncomment to have history ignore duplicates

# Uncomment the following line if you don't like systemctl's auto-paging feature
# export SYSTEMD_PAGER=

export JAVA_HOME=/usr

export EDITOR="/usr/bin/vim"
