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

ghdl_m=($(grep -n 'ghdl -m' sh_code_block.sh | cut -f1 -d:))
ghdl_e=($(grep -n 'ghdl -e' sh_code_block.sh | cut -f1 -d:))
ghdl_r=($(grep -n 'ghdl -r' sh_code_block.sh | cut -f1 -d:))
ghdl_elab_run=($(grep -n 'ghdl --elab-run' sh_code_block.sh | cut -f1 -d:))

num_m=${#ghdl_m[@]}
num_e=${#ghdl_e[@]}
num_r=${#ghdl_r[@]}
num_elab_run=${#ghdl_elab_run[@]}

if [[ $num_m == 0 && $num_e == 0 &&  $num_r == 0 && $num_elab_run == 0 ]] then 
    echo "ERROR: Cannot find an option to search the top" 
    exit
elif [[ $num_m > 1 || $num_e > 1 ||  $num_r > 1 || $num_elab_run > 1 ]] then
    echo "ERROR: the same option (make|elab|run|elab-run) is used several times" 
    exit
fi 

if [[ $num_m == 1 ]] then
  m_line=($(sed -n ''"$((${ghdl_m}))"'p' sh_code_block.sh))  

  for i in $(seq $((${#m_line[@]} - 1)) -1 0)
  do
    if [[ ${m_line[$i]:0:2} != "--" && ${m_line[$i]:0:1} != '\' ]] then
      m_top=${m_line[$i]}
      echo "The code top name is <${m_line[$i]}> (extracted from -m option)"
      break
    fi
  done
fi

if [[ $num_e == 1 ]] then
  e_line=($(sed -n ''"$((${ghdl_e}))"'p' sh_code_block.sh))  

  for i in $(seq $((${#e_line[@]} - 1)) -1 0)
  do
    if [[ ${e_line[$i]:0:2} != "--" && ${e_line[$i]:0:1} != '\' ]] then
      e_top=${e_line[$i]}
      echo "The code top name is <${e_line[$i]}> (extracted from -e option)"
      break
    fi
  done
fi

if [[ $num_r == 1 ]] then
  r_line=($(sed -n ''"$((${ghdl_r}))"'p' sh_code_block.sh))  

  for i in $(seq $((${#r_line[@]} - 1)) -1 0)
  do
    if [[ ${r_line[$i]:0:2} != "--" && ${r_line[$i]:0:1} != '\' ]] then
      r_top=${r_line[$i]}
      echo "The code top name is <${r_line[$i]}> (extracted from -r option)"
      break
    fi
  done
fi

if [[ $num_elab_run == 1 ]] then
  elab_run_line=($(sed -n ''"$((${ghdl_elab_run}))"'p' sh_code_block.sh))  

  for i in $(seq $((${#elab_run_line[@]} - 1)) -1 0)
  do
    if [[ ${elab_run_line[$i]:0:2} != "--" && ${elab_run_line[$i]:0:1} != '\' ]] then
      elab_run_top=${elab_run_line[$i]}
      echo "The code top name is <${elab_run_line[$i]}> (extracted from --elab-run option)"
      break
    fi
  done
fi

top=($m_top $e_top $r_top $elab_run_top)
k=0

for i in "${top[@]}"
do
    if [[ $k > 0 ]] then
        if [[ $i != ${top[$k-1]} ]] then
        echo "ERROR: Different top names have been scanned"
        exit
        fi
    fi
  k=$(($k+1))
done

echo "All scanned tops have the same name: <${top[0]}>"
echo ${top[0]} > top.txt
