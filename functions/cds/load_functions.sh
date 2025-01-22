BASHPATH="$(dirname "${BASH_SOURCE[0]}")"
for p in $(ls $BASHPATH/src)
do
# echo $PATH_CDS/src/$p
source $BASHPATH/src/$p -A export
done
cds_load
