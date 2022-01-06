#!/bin/bash
read -p "Enter Starting Point of scan(e.g 0.95): " spoint
read -p "Enter Ending Point of scan(e.g 1.05):  "  epoint
read -p "Enter Number Points of scan:  "  npoints
step=`echo "scale=5;(${epoint}-${spoint})/(${npoints}-1)"|bc`
echo "The length of scan is ${step}."
for((i=0;i<${npoints};i++))
do
scaling_rate=$(printf "%.5f" `echo "${spoint}+$i*${step}"|bc`)
mkdir $scaling_rate
echo "Create the ${scaling_rate} directory and move the modified POSCAR to  ${scaling_rate}"
gawk 'NR==1{print $0}' POSCAR >${scaling_rate}/POSCAR
gawk 'NR==2{print $0}' POSCAR >>${scaling_rate}/POSCAR
gawk -v a=$scaling_rate 'NR==3{$1=$1*a;$2=$2*a;printf "\t %-20.15f \t %20.15f \t %s\n",$1,$2,$3}' POSCAR>> ${scaling_rate}/POSCAR
gawk -v a=$scaling_rate 'NR==4{$1=$1*a;$2=$2*a;printf "\t %-20.15f \t %20.15f \t %s\n",$1,$2,$3}' POSCAR>> ${scaling_rate}/POSCAR
gawk 'NR>4{print $0}' POSCAR >> ${scaling_rate}/POSCAR
done
