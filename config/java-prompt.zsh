#!/usr/local/bin/zsh

JAVA=`which java`

[[ -x $JAVA ]] && $JAVA -version 2>&1 | awk '/version/{print $NF}' | tr -d \"
