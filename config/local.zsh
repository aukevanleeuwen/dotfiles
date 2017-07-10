# color codes in zsh (used mainly in prompt coloring)
export reset=$'%{\e[0;00m%}'
export gray=$'%{\e[0;90m%}'
export red=$'%{\e[0;31m%}'
export green=$'%{\e[0;32m%}'
export yellow=$'%{\e[0;33m%}'
export blue=$'%{\e[0;34m%}'
export magenta=$'%{\e[0;35m%}'
export cyan=$'%{\e[0;36m%}'
export white=$'%{\e[0;37m%}'

# Java version prompt
function ___java_prompt {
  echo "${gray}java-$(source ~/.dotfiles/config/java-prompt.zsh)$reset"
}

# rbenv support
if which rbenv > /dev/null; then
  eval "$(rbenv init - zsh)";
fi

HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000

# be like emacs (and bash)
bindkey -e

# Set prompt
setopt prompt_subst
PROMPT='$(~/.dotfiles/script/prompt $?)'
RPROMPT='$(___java_prompt)'

export SHELL=$(which zsh)

# Stuff I don't really understand, but I was told to use

setopt append_history share_history histignorealldups
setopt autocd beep extendedglob nomatch
setopt hist_ignore_all_dups
unsetopt auto_name_dirs

# Use brew zsh_completions
fpath=($fpath ~/.dotfiles/completions)

autoload -Uz compinit
compinit

# http://chneukirchen.org/blog/archive/2011/02/10-more-zsh-tricks-you-may-not-know.html
# Move to where the arguments belong.
after-first-word() {
  zle beginning-of-line
  zle forward-word
}
zle -N after-first-word
bindkey "^b" after-first-word

# make the home key work
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

# color!
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;35:*.rb=00;31'

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=00;31'
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# http://chneukirchen.org/blog/archive/2011/02/10-more-zsh-tricks-you-may-not-know.html
# Complete in history with M-/, M-,
zstyle ':completion:history-words:*' list no
zstyle ':completion:history-words:*' menu yes
zstyle ':completion:history-words:*' remove-all-dups yes
bindkey "\e/" _history-complete-older
bindkey "\e," _history-complete-newer

# Edits bij AvL
# Function + Delete
bindkey "^[[3~" delete-char
# Option + Right/Left
bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word
# PageUp/PageDown
bindkey "^[[5~" history-beginning-search-backward
bindkey "^[[6~" history-beginning-search-forward

# Fallback to autocomplete files (for autocompletion a parameter for example)
zstyle ':completion:*' completer _complete _ignored _files

# jEnv
if which jenv > /dev/null; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"; 
fi

# Own scripts directory
export PATH="$HOME/projects/scripts:$PATH"

# Homebrew doesn't set this by itself
export PYTHONPATH=/usr/local/lib/python2.7/site-packages

findport () {
  sudo lsof -n -P -iTCP:$1 -sTCP:LISTEN
}

split-threaddump () {
  gcsplit -z --prefix=$1 --digits=1 $1 '/dump Java HotSpot/' '{*}'
  
  for file in $1?; do 
    cat "$file" | perl -pe 's/^.*?\]: //e;' > "$file.clean"
    rm "$file"
  done
}
