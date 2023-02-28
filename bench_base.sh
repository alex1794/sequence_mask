#!/bin/bash

# if [ $# -ne 1 ]; then
# 	echo -e "Usage: $0 <Number of OpenMP threads>"
# else
echo -e "\nGCC\n"
for (( c=1; c<=31; c++ )); do
	echo $c
	./base_gcc s1.dna s2.dna > output.txt
	values=$(cut -c 39- output.txt | sed 's/elapsed(s)//g' | sed 's/GB\/s//g' | sed 's/;//g')
	# echo $values
	echo $values >> time_$base_gcc.txt
done

echo -e "\nCLANG\n"
for (( c=1; c<=31; c++ )); do
	echo $c
	./base_clang s1.dna s2.dna > output.txt
	values=$(cut -c 39- output.txt | sed 's/elapsed(s)//g' | sed 's/GB\/s//g' | sed 's/;//g')
	# echo $values
	echo $values >> time_$base_clang.txt
done

echo -e "\nICX\n"
for (( c=1; c<=31; c++ )); do
	echo $c
	./base_icx s1.dna s2.dna > output.txt
	values=$(cut -c 39- output.txt | sed 's/elapsed(s)//g' | sed 's/GB\/s//g' | sed 's/;//g')
	# echo $values
	echo $values >> time_$base_icx.txt
done

rm output.txt

