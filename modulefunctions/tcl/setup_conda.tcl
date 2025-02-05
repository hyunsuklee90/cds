#%Module1.0

proc setup_conda { conda_dir } {
    conflict anaconda

    prepend-path PATH "$conda_dir/bin"

    setenv CONDA_EXE "$conda_dir/bin/conda"
    setenv CONDA_PREFIX "$conda_dir"
    setenv CONDA_PYTHON_EXE "$conda_dir/bin/python"
    setenv ANACONDA_HOME "$conda_dir"
    setenv CONDA_SHLVL "0"

    if { [module-info mode load] } {
        puts stderr "Anaconda3 has been loaded."
    }

    if { [module-info mode unload] } {
        unsetenv CONDA_EXE
        unsetenv CONDA_PREFIX
        unsetenv CONDA_PYTHON_EXE
        unsetenv ANACONDA_HOME
        unsetenv CONDA_SHLVL
        
        remove-path PATH "$conda_dir/bin"
        
        puts stderr "Anaconda3 has been unloaded."
    }
}
