#!/usr/bin/env bash

check_util(){
  if ! [ -x "$(command -v $1)" ]; then
    echo -e "[x] $1 is not installed..."
  fi
}

trim() { 
  sed 's/^[[:space:]]*//g' <<<$1
}

check_util "cpanm"
if [ $? -eq 0 ]; then
  cpanm --installdeps .
else
  echo -e '[*] Install perl-dependencies manually.'
fi

declare -A shells=( ["/bin/bash"]="$HOME/.bashrc" ["/bin/sh"]="$HOME/.bashrc"
                    ["/bin/zsh"]="$HOME/.zshrc" ["/bin/ksh"]="$HOME/.kshrc" 
                    ["/bin/csh"]="$HOME/.cshrc" )

srcfile=${shells[$(trim $(finger $USER | grep 'Shell:*' | cut -f3 -d ":"))]}
printf "\nalias uc=\"perl $PWD/decompressor.pl\"" >> $srcfile