
for p in $(ls $PATH_CDS/src)
do
# echo $PATH_CDS/src/$p
source $PATH_CDS/src/$p -A export
done
cds_load
