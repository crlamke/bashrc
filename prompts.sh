#!/usr/bin/env bash
#Project Home: https://github.com/crlamke/bashrc
#Copyright   : 2025 Chris Lamke
#License     : MIT - See https://opensource.org/licenses/MIT

prompts=(
  "\[\e[36;1m\]\h:\[\e[32;1m\]\w$ \[\e[0m\]"
  "\n\[\033[01;32m\]\u@\h \D{%F %T}\[\033[0m\]\n\[\033[0;32m\][\$?] \w\[\033[0m\] \n[\!]->"
  "\u@\h:\w\$"
  "\[$(tput bold)$(tput setb 4)$(tput setaf 7)\]\u@\h:\w $ \[$(tput sgr0)\]"
)
promptsAvailable=${#prompts[@]}

function setprompt()
{
  if [ $# -eq 0 ]; then
    printf "Usage: setprompt prompt-index\n"
    printf "Ex: setprompt 1\n"
    return
  fi

  promptIndex=$1
  maxPromptIndex=$promptsAvailable-1
  if [[ $promptIndex -gt $maxPromptIndex  || $promptIndex -lt 0 ]]; then
    printf "Invalid prompt index %d\tValid indexes are 0 to %s\n" \
      "$promptIndex" "$maxPromptIndex"
  else
    export PS1=${prompts[${promptIndex}]}
  fi
}


RESET="\[\017\]"
NORMAL="\[\033[0m\]"
RED="\[\033[31;1m\]"
YELLOW="\[\033[33;1m\]"
WHITE="\[\033[37;1m\]"
SMILEY="${WHITE}:)${NORMAL}"
FROWNY="${RED}:(${NORMAL}"
SELECT="if [ \$? = 0 ]; then echo \"${SMILEY}\"; else echo \"${FROWNY}\"; fi"

# Throw it all together
#PS1="${RESET}${YELLOW}\h${NORMAL} \`${SELECT}\` ${YELLOW}>${NORMAL} "

# Colors
GREEN='\[\e[0;32m\]'
RED='\[\e[0;31m\]'
CYAN='\[\e[0;36m\]'
WHITE='\[\e[0;37m\]'
YELLOW='\[\e[0;33m\]'
PURPLE='\[\e[0;35m\]'

# Bold colors
BGREEN='\[\e[1;32m\]'
BRED='\[\e[1;31m\]'
BCYAN='\[\e[1;36m\]'
BWHITE='\[\e[1;37m\]'
BYELLOW='\[\e[1;33m\]'
BPURPLE='\[\e[1;35m\]'

PROMPT_COMMAND=prompt_profile

function prompt_profile()
{
if [ "$?" -eq "0" ]
then
  STATUS="${GREEN}✓"                              #✓
else
  STATUS="${RED}✘"                                #✘
fi


if [ "$UID" -eq "0" ]
then
  USERCOLOR="${BRED}"
else
  USERCOLOR="${BGREEN}"
fi

#PS1="${debian_chroot:+($debian_chroot)}${WHITE}┌─${WHITE}[${USERCOLOR}\u${PURPLE}@\h${WHITE}] ${BYELLOW}|\t|\n${WHITE}└──► ${STATUS}\[\e[0m\]\[\e[1;31m\]\[\e[0m\] ${CYAN}\w${WHITE}$ "

}


#it's a two line prompt and it shows (in order):
#first line
#- the logged user's name in green if it is a normal user, red if it is root;
#- your hostname in purple;
#- the time in yellow;
#
#second line
#- a green checkmark if your last command was successful, or a red cross if it wasn't;
#
#- your current path in cyan;
#-lastly the default $/# depending on the currently logged user


#Prompt structure
#  - first line
#    - the logged user's name in green if it is a normal user, red if it is root;
#    - your hostname in purple;
#    - the time in yellow;
#  - second line
#    - a green checkmark if your last command was successful, or a red cross if it wasn't;
#    - your current path in cyan;
#    -lastly the default $/# depending on the currently logged user
