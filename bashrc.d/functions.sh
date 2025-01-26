FUNCTIONS_DIR=$CDS_HOME/functions

export CDS_DATAPATH=$CDS_HOME/config/$CDS_ENV

# 모든 *.f 파일 찾고 로드
if [ -d "$FUNCTIONS_DIR" ]; then
    for file in $(find "$FUNCTIONS_DIR" -type f -name "*.sh"); do
        [ -r "$file" ] && source $file -A export
    done
else
    echo "Warning: Functions directory not found!" >&2
fi

if [ ! -d "$CDS_DATAPATH/data" ]; then
    mkdir -p $CDS_DATAPATH/data
fi

cds_load
