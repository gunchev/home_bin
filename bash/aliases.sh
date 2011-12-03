# Common ls aliases (RHEL, Fedora)
alias l='ls -Fax'
alias ll='ls -Alg'

# show hidden files and directories
alias l.='ls -d .[^.]* ..?* --color=tty 2>/dev/null'

# alias ls='ls -F -X -B -T 0 --color=tty'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

alias lll='ls -Al "--time-style=+%Y-%m-%d %H:%M:%S %4Z"'

# Subversion
alias svnign='svn propedit svn:ignore "$@"'

# color grep
alias grep='grep --colour=auto'

# color less (restricted)
alias less='less -R'
