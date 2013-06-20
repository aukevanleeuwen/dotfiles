#!/usr/local/bin/zsh

java -version 2>&1 | awk '/version/{print $NF}' | tr -d \"
