# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

# git bash prompt
export PS1='\u@\h \W$(declare -F __git_ps1 &>/dev/null && __git_ps1 " (%s)") '
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true

# completions
source /etc/profile.d/bash_completion.sh
source /usr/share/git-core/contrib/completion/git-prompt.sh

# autocompletions
complete -C /usr/bin/aws_completer aws
source <(kubectl completion bash)
source <(kind completion bash)
