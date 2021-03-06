export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PYTHONIOENCODING=utf_8

# Setting the editor of choice
export EDITOR='vim'
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR
export SVN_EDITOR=$EDITOR
export BUNDLER_EDITOR=$EDITOR
export GEMEDITOR=$EDITOR

# Ruby Optimalizations
export RUBY_GC_HEAP_INIT_SLOTS=1100000
export RUBY_GC_MALLOC_LIMIT=110000000
export RUBY_HEAP_FREE_MIN=20000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1

# Paths
export PATH="/usr/local/bin:$PATH"
if [[ -d "/usr/local/sbin" ]]; then
  export PATH=$PATH:/usr/local/sbin
fi
export PATH=$PATH:$HOME/.dotfiles/bin
# Load Node.js bin:
export PATH="/usr/local/share/npm/bin:$PATH"
export NODE_PATH="/usr/local/lib/node_modules"
if [[ -d "/opt/chefdk" ]]; then
  export PATH="/opt/chefdk/embedded/bin:${HOME}/.chefdk/gem/ruby/2.4.0/bin:$PATH"
fi
export PATH=$PATH:$HOME/projects/tools/jacoco
export MAVEN_OPTS="-Xmx1536M -Djavax.xml.accessExternalSchema=all"

# General aliases
alias l='ls -halo'
alias ltr='ls -lt'
alias lth='l -t|head'
alias lh='ls -Shl | less'
alias tf='tail -f -n 100'
alias less='less -R' # color codes in less
alias m='mvim --remote-silent' # open file in existing mvim
alias grep='grep --colour=always'
alias pstree='pstree -g 3'
alias k='/usr/local/bin/kubectl'
alias irb='pry'

# checks to see if bundler is installed, if it isn't it will install it
# checks to see if your bundle is complete, runs bundle install if it isn't
# if any arguments have been passed it will run it with bundle exec
function b() {
  gem which bundler > /dev/null 2>&1 || gem install bundler --no-ri --no-rdoc
  bundle check || bundle install
  if [ $1 ]; then
    bundle exec $*
  fi
}

# unstage and by making it a function it will autocomplete files
unstage() {
  git reset HEAD -- $*
  echo
  git status
}

function github-init () {
  git config branch.$(git-branch-name).remote origin
  git config branch.$(git-branch-name).merge refs/heads/$(git-branch-name)
}

function github-url () {
  git config remote.origin.url | sed -En 's/git(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\3\/\4/p'
}

# Seems to be the best OS X jump-to-github alias from http://tinyurl.com/2mtncf
function github-go () {
  open $(github-url)
}

function run-tests() {
  if [ ! -p ~/.vim/commands-fifo ]; then
    mkfifo ~/.vim/commands-fifo
  fi
  while true; do
    cmd="$(cat ~/.vim/commands-fifo)"
    if [ -n "$cmd" ]; then
      echo
      echo "\e[33m$cmd\e[0m"
      echo
      sh -c $cmd
    fi
  done
}

# grep for a process
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

function jwt-decode() {
  # (1) strip OpenAM prefix
  # (2) split on ., keep header/payload
  # (3) split header/payload with newline
  # (4) base64 decode and display
  sed -E 's/^\*[^\*]+\*//' <<< $1 \
    | cut -d"." -f1,2 \
    | tr '.' '\n' \
    | base64 -D \
    | jq .
}
