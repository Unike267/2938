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
sh_begin=($(grep -n '```sh' ../issue.txt | cut -f1 -d:))

if [[ ${#sh_begin[@]} > 1 ]] then 
    echo "ERROR: Please, use ONLY one SH block" 
    exit
fi 

echo "The SH initial line is:"

echo "${sh_begin}"


flag=0
k=0
for i in "${all_quotes[@]}"
do
    if [[ ${sh_begin} == $i ]] then 
        flag=1
    elif [[ $flag == 1 ]] then
        sh_end=${i}
        flag=0
    fi 
done

if [[ ${#sh_end[@]} > 1 ]] then 
    echo "ERROR" 
    exit
fi 

echo "Their final lines are:"
echo "${sh_end}"
 
echo "Extract code-blocks:"
sed -n ''"$((${sh_begin}+1))"','"$((${sh_end}-1))"'p;'"$((${sh_end}))"'q' ../issue.txt > sh_code_block.sh
