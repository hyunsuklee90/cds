#!/bin/bash

export CDS_PATH="$(dirname "${BASH_SOURCE[0]}")"

#if [ -f $CDS_PATH/configure ]; then
#    source $CDS_PATH/configure
#else
#    echo "Warning: configure file not found! while loading cds"
#    echo "CDS_ENV is set to temp"
#    export CDS_ENV=temp
#fi
#export CDS_ENV=laptop
export CDS_ENV=kaeri_ext

# Load all scripts in bashrc.d
for file in $CDS_PATH/bashrc.d/*.sh; do
  [ -r "$file" ] && source "$file"
done

if [ ! -d $CDS_PATH/config/$CDS_ENV ]; then
	mkdir $CDS_PATH/config/$CDS_ENV
fi
# Load System dependent bashrc
if [ -d $CDS_PATH/config/$CDS_ENV ]; then
    for file in $CDS_PATH/config/$CDS_ENV/*.sh; do
        [ -r "$file" ] && source "$file"
    done
else
    echo "Error: Configuration for environment '$CDS_ENV' not found."
fi

unset CDS_PATH
