#!/bin/bash

# ps-twtty-7.sh - Nice bash prompt and history archiver
#   by Doncho Gunchev <dgunchev@gmail.com>, 2015-08-03 13:00 EET
#   Change the root prompt colors

# ps-twtty-7.sh - Nice bash prompt and history archiver
#   by Doncho N. Gunchev <dgunchev@gmail.com>, 2011-11-10 12:12 EET
#   fixed some variable quoting

# ps-twtty-7.sh - Nice bash prompt and history archiver
#   by Doncho N. Gunchev <dgunchev@gmail.com>, 2008-09-30 07:00 EEST

# BASED ON
# termwide prompt with tty number  and  .bashrc_history.sh
# by Giles, 1998-11-02                  by Yaroslav Halchenko, 2005-03-10
# .../Bash-Prompt-HOWTO/x869.html       http://www.onerussian.com

# DESCRIPTION
# An attempt to seese industrial... ops, I ment an attempt to make my
# bash prompt nicer and save all my bash history ordered by date with
# exit codes for later review...

# LICENSE:
#   Released under GNU Generic Public License. You should've received it with
#   your GNU/Linux system. If not, write to the Free Software Foundation, Inc.,
#   59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

# KNOWN BUGS:
# - logs the previous command again on control-break, control-quit
# - logs the last command in history on control+d (EOF) or enter
#   (could be fixed if we remember the index of the command used last time,
#   which is currently removed by 'Cmd=${Cmd:7}')
# - does not log history from within mc (midnight commander)
#   this can be viewed as a feature too :-) The problem is that mc
#   changes PROMPT_COMMAND, hurting the prompt quite bad and
#   killing the log.

if [ "$PS1" ] ; then # interactive shell detection

function prompt_command_exit() {
	trap - EXIT
	# mark the logout
	local HistFile="$HOME/bash_history/$(date '+%Y-%m/%Y-%m-%d')"
	mkdir -p "${HistFile%/*}"
	local Cmd="$(history 1)"
	#Cmd=$(echo "$Cmd" | sed 's/^ *[[:digit:]][[:digit:]]* *//')
	Cmd="${Cmd:7}"
	echo -e "# Logout,$USER@${HOSTNAME}:$PWD,$(tty),${SSH_CLIENT:-$(who am i | cut -d ' ' -f 1)@localhost},${my_LoginTime},$(date --rfc-3339=ns)\n$Cmd" >> "$HistFile"
}

function prompt_command() {
	# Save the error code
	local E=$?

	# Date, my format
	my_D="$(date '+%Y-%m-%d %H:%M:%S')"

	local HistFile="$HOME/bash_history/$(date '+%Y-%m/%Y-%m-%d')"
	mkdir -p "${HistFile%/*}"

	# Manage the history
	if [ -z "$my_LoginTime" ]; then
		my_LoginTime=$(date --rfc-3339=ns)
		echo -e "# Login,$USER@${HOSTNAME}:$PWD,$(tty),${SSH_CLIENT:-$(who am i | cut -d ' ' -f 1)@localhost},${my_LoginTime},${my_LoginTime}\n" >> "$HistFile"
	else
		local Cmd="$(history 1)"
		#Cmd=$(echo "$Cmd" | sed 's/^ *[[:digit:]][[:digit:]]* *//')
		Cmd="${Cmd:7}"
		echo -e "# CMD,\$?=$E,$USER@${HOSTNAME}:$PWD,$(tty),${SSH_CLIENT:-$(who am i | cut -d ' ' -f 1)@localhost},${my_LoginTime},$(date --rfc-3339=ns)\n$Cmd" >> "$HistFile"
	fi


	# Calculate the width of the prompt:
	my_TTY="$(tty)"
	my_TTY="${my_TTY:5}"	# cut the '/dev' part -> tty/1, pts/2...
	# Add all the accessories below ...
	local prompt="--($my_D, Err $E, $my_TTY)---($PWD)--"

	local fillsize=0
	let fillsize=${COLUMNS}-${#prompt}
	my_FILL=""
	if [ $fillsize -gt 0 ]; then
		my_FILL="─"
		while [ $fillsize -gt ${#my_FILL} ]; do
			my_FILL="${my_FILL}${my_FILL}${my_FILL}${my_FILL}"
		done
		my_FILL="${my_FILL::$fillsize}"
		let fillsize=0
	fi

	if [ $fillsize -lt 0 ]; then
		my_PWD="...${PWD:3-$fillsize}"
	else
		my_PWD="${PWD}"
	fi
}

function twtty {
	local GRAY="\[\033[1;30m\]"
	local LIGHT_GRAY="\[\033[0;37m\]"
	local WHITE="\[\033[1;37m\]"
	local NO_COLOUR="\[\033[0m\]"

	local LIGHT_BLUE="\[\033[1;34m\]"
	local YELLOW="\[\033[1;33m\]"

	local RED="\[\033[0;31m\]"
	local LIGHT_RED="\[\033[1;31m\]"

	if [ "${UID}" -ne "0" ]; then
		# Normal user colors
		local C1="${YELLOW}"
		local C2="${LIGHT_BLUE}"
		local C3="${WHITE}"
	else
		# root user colors
		local C1="${LIGHT_RED}"
		local C2="${YELLOW}"
		local C3="${WHITE}"
	fi


	case "$TERM" in
		xterm*)
			TITLEBAR='\[\033]0;\u@\h:\w\007\]'
			;;
		*)
			TITLEBAR=""
			;;
	esac

	PS1="$TITLEBAR\
${C1}┌${C2}─(\
${C1}\${my_D}${C2}, ${C1}Err ${C3}\$?${C2}, ${C3}\${my_TTY}\
${C2})─${C1}─\${my_FILL}${C2}─(\
${C1}\${my_PWD}\
${C2})─${C1}─\
${NO_COLOUR}\n\
${C1}└${C2}─(\
${C1}\${USER}${C2}@${C1}\${HOSTNAME%%.*}\
${C2})${C3}\$${NO_COLOUR} "

	PS2="${C2}─${C1}─${C1}─${NO_COLOUR} \[\033[K\]"
	PROMPT_COMMAND=prompt_command
	trap prompt_command_exit EXIT
	shopt -s cmdhist histappend
	export HISTCONTROL='ignorespace:erasedups'
	export HISTIGNORE='history:history *'
}

twtty
unset twtty

fi
