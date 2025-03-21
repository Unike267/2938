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
    echo "Cannot find the top" 
    exit
fi 

#TO-DO
