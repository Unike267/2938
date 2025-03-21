#!/usr/bin/env bash

# Author:
#   Unai Sainz-Estebanez
# Email:
#  <unai.sainze@ehu.eus>
#
# Licensed under the GNU General Public License v3.0;
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.gnu.org/licenses/gpl-3.0.html

set -e

cd $(dirname "$0")

all_quotes=($(grep -n '```' ../issue.txt | cut -f1 -d:))
vhd_begin=($(grep -n '```vhd' ../issue.txt | cut -f1 -d:))

num_blocks_x2=${#all_quotes[@]}
num_vhd_blocks=${#vhd_begin[@]}

echo "There are $((num_blocks_x2/2)) codeblocks of which $num_vhd_blocks are VHDL"

echo "The VHDL initial lines are:"
for i in "${vhd_begin[@]}"
do
    echo $i
done

flag=0
k=0

for i in "${all_quotes[@]}"
do
    if [[ ${vhd_begin[k]} == $i ]] then 
        flag=1
        k=$(($k+1))
    elif [[ $flag == 1 ]] then
        vhd_end[$(($k-1))]=${i} #sure there is a better way to do this
        flag=0
    fi 
done

if [[ ${#vhd_begin[@]} != ${#vhd_end[@]} ]] then 
    echo "ERROR: vhd_begin != vhd_end" 
    exit
fi 

echo "Their final lines are:"
for i in "${vhd_end[@]}"
do
    echo "$i"
done
 
echo "Extract code-blocks:"
for ((i=0;i<num_vhd_blocks;i++))
do
   sed -n ''"$((${vhd_begin[i]}+1))"','"$((${vhd_end[i]}-1))"'p;'"$((${vhd_end[i]}))"'q' ../issue.txt > vhd_code_block_"$(($i+1))".vhd
done
