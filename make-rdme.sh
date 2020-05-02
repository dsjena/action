#!/bin/bash


op="README.md"
cat main.md > $op
echo "" >> $op
#echo "" >> $op
#echo "" >> $op
echo "# Recieved " >> $op
echo "" >> $op

#echo > $op
printf  "|:-----:|:-----:|:------:| \n" >> $op
i=$(< recieved.md wc -l)
echo $i
a=$((i/3))
b=$((a+1))
c=$((b*3))
echo $a
echo $b
echo $c

j=0
while read line
do
  kk=$((j%3))
  #echo $kk $j
  if [ $kk == 2 ]; then
    printf "$line" >> $op
    printf " | \n" >> $op
  elif [ $kk == 0 ]; then
    printf "| $line" >> $op
    printf " | ">> $op
  else  
    printf "$line" >> $op
    printf " | ">> $op
  fi
  j=$((j+1))
done < recieved.md
#
while ((j<=c)); do
    kk=$((j%3))
  #echo $kk $j
  if [ $kk == 2 ]; then
    printf " - " >> $op
    printf " | \n" >> $op
  else 
    printf " - " >> $op
    printf " | ">> $op
  fi
  j=$((j+1))
done
printf  "|:-----:|:-----:|:------:| \n" >> $op
#----------------

echo "# Processed " >> $op
echo "" >> $op


#echo > $op
printf  "|:-----:|:-----:|:------:| \n" >> $op
i=$(< processed.md wc -l)
echo $i
a=$((i/3))
b=$((a+1))
c=$((b*3))
echo $a
echo $b
echo $c

j=0
while read line
do
  kk=$((j%3))
  #echo $kk $j
  if [ $kk == 2 ]; then
    printf "$line" >> $op
    printf " | \n" >> $op
  else 
    printf "$line" >> $op
    printf "| ">> $op
  fi
  j=$((j+1))
done < processed.md
#
while ((j<=c)); do
  kk=$((j%3))
  #echo $kk $j
  if [ $kk == 2 ]; then
    printf " - " >> $op
    printf " | \n" >> $op
  else 
    printf " - " >> $op
    printf "| ">> $op
  fi
  j=$((j+1))
done
printf  "|:-----:|:-----:|:------:| \n" >> $op
#----------------


#
#echo "" >> $op
#
####echo "# Processed " >> $op




#list=()
#while IFS= read -r line; do
#  list+=("$line")
#done < recieved.md
#while read line; 
#do 
#  echo $line
#  mm="\"$line\""
#  list+=($mm)
#done < recieved.md
#j=${#list[@][1]}
#echo $j
#m="- - - - -"
#while ((j<=c)); 
#do
#   list+=($m)
#done
#k=${#list[@]}
#echo $k
#
#for ((ii=0; ii<c; ++ii))
#do
#  echo ${list[$ii][0]}
#done
