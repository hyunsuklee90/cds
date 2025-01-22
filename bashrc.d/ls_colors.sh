# export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:di=1;33:"
# export LS_COLORS='auto'
# export LS_COLORS="ow=1;34:tw=1;34:di=1;4;31;42:"
# test -r $HS/profiles/.dir_colors && eval $(dircolors $HS/profiles/.dir_colors)

if [ -f CDS_HOME/config/dir_colors ]; then
    eval "$(dircolors -b CDS_HOME/config/dir_colors)"
fi

export LS_COLORS=$LA_COLORS:"ow=1;34:tw=1;34:di=1;33:"
