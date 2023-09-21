HISTFILE=~/.config/zsh/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

# for bash completion because aws
autoload bashcompinit && bashcompinit

# completion engine
zstyle :compinstall filename '/home/slofl/.config/zsh/.zshrc'
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# completions
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 
source <(kubectl completion zsh)
complete -C /usr/bin/aws_completer aws

# prompt
autoload -U colors && colors
export PS1="%B%{$fg[green]%}%n%{$fg[magenta]%}@%{$fg[green]%}%M %{$fg[magenta]%}%~%{$reset_color%}%b "
