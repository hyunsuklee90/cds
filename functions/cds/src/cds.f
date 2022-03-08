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
      echo ${SCPATH[$(cds_get_i $2)]}
   else
      echo ""
      echo " [idx|name]: path"
      echo ""
      while [  "x${SCPATH[$i]}" != "x" ]
      do
         # echo " $i [${SCIDX[$i]}|${SCNAME[$i]}]: ${SCPATH[$i]}"
         echo " [${SCIDX[$i]}|${SCNAME[$i]}]: ${SCPATH[$i]}"
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
"-s" | "-sp")
   cds_get_i $2
   i1=$idx
   cds_get_i $3
   i2=$idx
   if [[ $i1 -ne 0 ]] && [[ $i2 -ne 0 ]]; then
      tmp=${SCPATH[$i1]}
      tmp2=${SCNAME[$i1]}

      SCPATH[$i1]=${SCPATH[$i2]}
      SCNAME[$i1]=${SCNAME[$i2]}

      SCPATH[$i2]=$tmp
      SCNAME[$i2]=$tmp2

      if [ "$1" =  "-s" ]; then
         tmp3=${SCIDX[$i1]}
         SCIDX[$i1]=${SCIDX[$i2]}
         SCIDX[$i2]=$tmp3
      fi

   fi
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
   let n=i
   # SCID[$i] = $i
;;

"-an" | "-cn")
   cds_get_i $2 # update idx
   if [[ $idx -ne 0 ]]; then
      echo "change shortcut name of $2 to $3"
      SCNAME[$idx]=$3
   fi
;;

"-ai" | "-ci")
   cds_get_i $3 0 # update idx
   if [[ $idx -ne 0 ]]; then
      # switch index
      i1=$idx
      cds_get_i $2 # update idx
      i2=$idx
      if [[ $idx -ne 0 ]]; then
         echo "switch shortcut index of $2 to $3"
         tmp=${SCIDX[$i1]}
         SCIDX[$i1]=${SCIDX[$i2]}
         SCIDX[$i2]=$tmp
      fi
   else
      cds_get_i $2 # update idx
      if [[ $idx -ne 0 ]]; then
         echo "change shortcut index of $2 to $3"
         SCIDX[$idx]=$3
      fi
   fi
;;

"-r" | "-rm")
   cds_get_i $2
   i=$idx
   if [[ $i -ne 0 ]]; then
      echo "short cut path $2 is removed : ${SCPATH[$i]}"
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
   fi
   let n=i
;;
*)
   cds_get_i $1 # update idx
   if [[ $idx -ne 0 ]]; then
      cd ${SCPATH[$idx]}
   fi
;;
esac
}

cds_get_i()
{
   for (( i=1; i<=$n; i++ ))
   do
      if [ "$1" = "${SCIDX[$i]}" ]; then
         idx=$i
         break
      fi
      if (( $i == $n )); then
         if (( $# == 1 )); then
         echo "index '$1' is not in the list"
         echo "check the available list"
         echo "cds -l"
         fi
         idx=0
      fi
   done
}
