# Aion development environment shortcut function
adev() {
    module load aion
    if [ -z "$1" ]; then
        # Just 'adev': Move to base directory, no conda activation
        cd "/mnt/d/OneDrive/0project/AionMC/aion"
    else
        # 'adev <task>': Activate environment and move to task directory
        conda activate "aion-$1"
        cd "/mnt/d/OneDrive/0project/AionMC/aion-$1"
    fi
}
