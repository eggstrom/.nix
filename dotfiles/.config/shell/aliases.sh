# Make sudo respect aliases
alias sudo='sudo '

# Better file manipulation
alias mv='mv -vi'
alias cp='cp -vir'
alias rm='rm -vir'
alias mkdir='mkdir -vp'
alias rmdir='rmdir -v'

# Colored output
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto'

# Miscellaneous
alias aria2c='aria2c -d $HOME/Downloads'
alias d='eval cd "$(dirs -p | fzf)"'
alias e='$EDITOR'
alias f='yazi'
alias l='eza -al --icons --git'