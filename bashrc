#!/bin/bash

export BASHPATH0="$(dirname "${BASH_SOURCE[0]}")"

#if [ -f $BASHPATH0/configure ]; then
#    source $BASHPATH0/configure
#else
#    echo "Warning: configure file not found! while loading cds"
#    echo "CURRENT_ENV is set to temp"
#    export CURRENT_ENV=temp
#fi
export CURRENT_ENV=laptop

# Load all scripts in bashrc.d
for file in $BASHPATH0/bashrc.d/*.sh; do
  [ -r "$file" ] && source "$file"
done

# Load System dependent bashrc
if [ -d $BASHPATH0/config/$CURRENT_ENV ]; then
    for file in $BASHPATH0/config/$CURRENT_ENV/*.sh; do
        [ -r "$file" ] && source "$file"
    done
else
    echo "Error: Configuration for environment '$CURRENT_ENV' not found."
fi

unset BASHPATH0
