#!/bin/bash

# if [ $# -ne 1 ]; then
# 	echo -e "Usage: $0 <Number of OpenMP threads>"
# else
scale[0]=1
# scale[1]=2
# scale[2]=4
# scale[3]=8
# scale[4]=16
# scale[5]=32
# scale[6]=64
# scale[7]=128
# scale[8]=256

echo -e "\nGCC\n"
for (( s=0; s<1; s++ )); do
	for (( c=1; c<=10; c++ )); do
		echo $c
		OMP_NUM_THREADS=${scale[$s]} ./mask_gcc s1.dna s2.dna > output.txt
		values=( $(cut -c 39- output.txt | sed 's/elapsed(s)//g' | sed 's/GB\/s//g' | sed 's/;//g') )
		echo ${values[0]} ${values[1]} >> time_align_gcc.txt
		echo ${values[2]} ${values[3]} >> time_unroll_gcc.txt
		echo ${values[4]} ${values[5]} >> time_intrin_gcc.txt
		echo ${values[6]} ${values[7]} >> time_align_omp_gcc.txt
		echo ${values[8]} ${values[9]} >> time_unroll_omp_gcc.txt
		echo ${values[10]} ${values[11]} >> time_intrin_omp_gcc.txt
	done

	echo -e "\nCLANG\n"
	for (( c=1; c<=31; c++ )); do
		echo $c
		OMP_NUM_THREADS=${scale[s]} ./mask_clang s1.dna s2.dna > output.txt
		values=( $(cut -c 39- output.txt | sed 's/elapsed(s)//g' | sed 's/GB\/s//g' | sed 's/;//g') )
		echo ${values[0]} ${values[1]} >> time_align_scale_clang.txt
		echo ${values[2]} ${values[3]} >> time_unroll_scale_clang.txt
		echo ${values[4]} ${values[5]} >> time_intrin_scale_clang.txt
		echo ${values[6]} ${values[7]} >> time_align_omp_clang.txt
		echo ${values[8]} ${values[9]} >> time_unroll_omp_clang.txt
		echo ${values[10]} ${values[11]} >> time_intrin_omp_clang.txt
	done

	echo -e "\nICX\n"
	for (( c=1; c<=31; c++ )); do
		echo $c
		OMP_NUM_THREADS=${scale[s]} ./mask_icx s1.dna s2.dna > output.txt
		values=( $(cut -c 39- output.txt | sed 's/elapsed(s)//g' | sed 's/GB\/s//g' | sed 's/;//g') )
		echo ${values[0]} ${values[1]} >> time_align_scale_icx.txt
		echo ${values[2]} ${values[3]} >> time_unroll_scale_icx.txt
		echo ${values[4]} ${values[5]} >> time_intrin_scale_icx.txt
		echo ${values[6]} ${values[7]} >> time_align_omp_icx.txt
		echo ${values[8]} ${values[9]} >> time_unroll_omp_icx.txt
		echo ${values[10]} ${values[11]} >> time_intrin_omp_icx.txt
	done
done

rm output.txt

