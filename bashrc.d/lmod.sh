if module --version &> /dev/null; then
    if [ ! -d "$CDS_DATAPATH/modulefiles" ]; then
        mkdir -p $CDS_DATAPATH/modulefiles
    fi
    #export MODULEPATH=/usr/share/lmod/lmod/modulefiles
    if [[ ":$MODULEPATH:" != *":$CDS_DATAPATH/modulefiles:"* ]]; then
        export MODULEPATH=$MODULEPATH:$CDS_DATAPATH/modulefiles
    fi
fi
