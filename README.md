# bashrc
This is a standalone .bashrc for use when you don't want to use something more complex like my https://github.com/crlamke/bash-startup-files.

I'm taking bug reports and suggestions for functionality. The easiest way to contact me is to tweet at me - https://twitter.com/crlamke.

## Current functionality 
1. Function setprompt() that allows you to select from various prompts you can easily add to the script (a few are provided)
2. Disk space function diskspace() that provides formatted disk stats designed to be easy to read 
3. backup convenience function back() that creates a .bak version of a single file
4. find convenience function find-list() that lists files matching a pattern
5. find convenience function find-do() that executes a command on files matching a pattern
6. System load function sysload() that gives you a one line snapshot of the current system load
7. Help function help() that prints out the script's functionality 
8. Helpful aliases
## Planned functionality
1. Improve back() function to back up sets of files 
2. Add delete function that creates backup of deleted files, preserving their attributes
3. Add dupe function that creates duplicate of a set of files, preserving their attributes
## Requirements to run script 
1. This script requires only bash v4.2 or newer in a full Linux environment. It's tested on CentOS 7 and Ubuntu 20 LTS. 
2. This script may partially work on limited environments like cygwin and GitBash (I use it with GitBash), but no guarantees.
3.   
