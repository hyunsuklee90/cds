#!/bin/bash

[[ $- != *i* ]] && return

if [ -z "$CDS_ENV" ]; then
    export CDS_ENV=default
fi

export CDS_HOME="$(dirname "${BASH_SOURCE[0]}")"
export CDS_DATAPATH=$CDS_HOME/config/$CDS_ENV

# Load all scripts in bashrc.d
for file in $CDS_HOME/bashrc.d/*.sh; do
    [ -r "$file" ] && source "$file"
done

if [ ! -d $CDS_HOME/config/$CDS_ENV ]; then
    mkdir $CDS_HOME/config/$CDS_ENV
fi
# Load System dependent bashrc
if [ -d $CDS_HOME/config/$CDS_ENV ]; then
    for file in $CDS_HOME/config/$CDS_ENV/*.sh; do
        [ -r "$file" ] && source "$file"
    done
else
    echo "Error: Configuration for environment '$CDS_ENV' not found."
fi

echo "HI"
