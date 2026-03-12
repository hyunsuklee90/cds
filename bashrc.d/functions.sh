FUNCTIONS_DIR=$CDS_HOME/functions

# 모든 *.sh 파일 찾고 로드
if [ -d "$FUNCTIONS_DIR" ]; then
    for file in $(find "$FUNCTIONS_DIR" -type f -name "*.sh"); do
        [ -r "$file" ] && source $file
    done
else
    echo "Warning: Functions directory not found!" >&2
fi

# 데이터 디렉토리 생성
if [ ! -d "$CDS_DATAPATH/data" ]; then
    mkdir -p $CDS_DATAPATH/data
fi

# CDS_MODE에 따른 초기화
# direct 모드일 때는 매번 파일을 읽으므로 초기 로드가 필요 없음.
# memory 모드일 때만 세션용 임시 버퍼를 생성함.
if [[ "${CDS_MODE:-direct}" == "memory" ]]; then
    if declare -f _cds_init_session > /dev/null; then
        _cds_init_session
    fi
fi
