FUNCTIONS_DIR=$BASHPATH0/functions

export DATAPATH_CDS=$BASHPATH0/config/$CURRENT_ENV

# 모든 *.f 파일 찾고 로드
if [ -d "$FUNCTIONS_DIR" ]; then
    for file in $(find "$FUNCTIONS_DIR" -type f -name "*.f"); do
        [ -r "$file" ] && source $file -A export
    done
else
    echo "Warning: Functions directory not found!" >&2
fi

cds_load
