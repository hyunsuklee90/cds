export OPENMC_CROSS_SECTIONS=$ONED/xslib/OpenMC/endfb-viii.0-hdf5/cross_sections.xml

export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH

if module --version &> /dev/null; then
    export MODULEPATH=$MODULEPATH:$CDS_HOME/config/common/modulefiles
fi
