#!/bin/bash

cds_save()
{
   rm -f $PATH_CDS/data/cds_*
   i=1
   while [  "x${SCPATH[$i]}" != "x" ]
   do
      echo [${SCNAME[$i]}] idx=${SCIDX[$i]} path=${SCPATH[$i]}
      echo ${SCPATH[$i]} >> $PATH_CDS/data/cds_path
      echo ${SCNAME[$i]} >> $PATH_CDS/data/cds_pathname
      echo ${SCIDX[$i]} >> $PATH_CDS/data/cds_idx
      let i=i+1
   done
}

cds_load()
{
   unset SCPATH SCNAME SCIDX

   if test -f $PATH_CDS/data/cds_path; then
      # read path from the file
      i=1
      while read line; do
         SCPATH[$i]=$line
         SCNAME[$i]="-"
         SCIDX[$i]=""
         let i=i+1
      done < $PATH_CDS/data/cds_path
      let n=i-1 # number of saved path

      i=1
      while read line; do
         SCNAME[$i]=$line
         let i=i+1
      done < $PATH_CDS/data/cds_pathname

      i=1
      for p in $(cat $PATH_CDS/data/cds_idx)
      do
         SCIDX[$i]=$p
         let i=i+1
      done

      # assign the idx if it is not assigned
      for (( i=1; i<=$n; i++ ))
      do
         if [ -z ${SCIDX[$i]} ]; then
            for (( j=1; j<=$n; j++ ))
            do
               found=0
               for (( k=1; k<=$n; k++ ))
               do
                  # echo loop $i $j $k ${SCIDX[$k]} $found
                  if [ ! -z ${SCIDX[$k]} ]; then
                     if (( ${SCIDX[$k]} == $j )); then
                        # echo $ found..!
                        found=1
                        break
                     fi
                  fi
               done
               if (($found == 0)); then
                  # echo set SCIDX to $j
                  SCIDX[$i]=$j
                  break
               fi
            done
         fi
         # echo ${SCIDX[$i]}
      done

   else
      n=0
   fi
}

cds()
{
case $1 in
"-h" | "-help")
   echo "usage: cds [option]"
   echo "arg ...  :"
   echo "-s       :"
   echo "-l       : print the list of path details"
   echo "-a       : add short cut path"
   echo "         cds -a     ;add shorcut to current pwd"
   echo "         cds -a 10  ;add shortcut to current pwd and set index to 10"
   echo "-r [idx] : remove shortcut path of index=[idx]"
;;
"-save")
   cds_save
;;
"-load")
   cds_load
;;
"-l")
   i=1
   if [ $# -eq 2 ]; then
      echo ${SCPATH[$2]}
   else
      while [  "x${SCPATH[$i]}" != "x" ]
      do
         # echo " $i [${SCIDX[$i]}|${SCNAME[$i]}]: ${SCPATH[$i]}"
         echo " $i [${SCIDX[$i]}|${SCNAME[$i]}]: ${SCPATH[$i]}"
         let i=i+1
      done
   fi
;;
"")
   i=1
   if [ $# -eq 2 ]; then
      echo ${SCPATH[$2]}
   else
      while [  "x${SCPATH[$i]}" != "x" ]
      do
         if [ "${SCNAME[$i]}" = "-" ]; then
            echo " ${SCIDX[$i]}  ${SCPATH[$i]}"
            let i=i+1
         else
            echo " ${SCIDX[$i]}  [${SCNAME[$i]}]"
            let i=i+1
         fi
      done
   fi
;;
"-s")
   tmp=${SCPATH[$2]}
   SCPATH[$2]=${SCPATH[$3]}
   SCPATH[$3]=$tmp
   tmp2=${SCNAME[$2]}
   SCNAME[$2]=${SCNAME[$3]}
   SCNAME[$3]=$tmp2
   tmp2=${SCIDX[$2]}
   SCIDX[$2]=${SCIDX[$3]}
   SCIDX[$3]=$tmp2
;;
"-a")
   i=1
   while [  "x${SCPATH[$i]}" != "x" ]
   do
      let i=i+1
   done
   if [ $# -eq 1 ]; then
      SCPATH[$i]=$(pwd)
   else
      SCPATH[$i]=$2
   fi

   SCNAME[$i]="-"
   SCIDX[$i]=$i

   echo "short cut path $i is added : ${SCPATH[$i]}"
   # SCID[$i] = $i
;;

"-an" | "-cn")
   echo "change shortcut name of $2 to $3"
   SCNAME[$2]=$3
;;

"-ai" | "-ci")
   echo "change shortcut index of $2 to $3"
   SCIDX[$2]=$3
;;

"-r")
   i=$2
   echo "short cut path $i is removed : ${SCPATH[$i]}"
   let j=i+1
   while  [  "x${SCPATH[$j]}" != "x" ]
   do
      SCPATH[$i]=${SCPATH[$j]}
      SCNAME[$i]=${SCNAME[$j]}
      SCIDX[$i]=${SCIDX[$j]}
      let i=i+1
      let j=j+1
   done
   SCPATH[$i]=""
   SCNAME[$i]=""
   SCIDX[$i]=""
;;
*)
   for (( i=1; i<=$n; i++ ))
   do
      # echo $1 ${SCIDX[$i]}
      if (( $1 == ${SCIDX[$i]} )); then
         cd ${SCPATH[$i]}
         break
      fi
      if (( $i == $n )); then
         echo "index is not found"
         echo "check the available list"
         echo "cds -l"
      fi
   done
;;
esac
}
