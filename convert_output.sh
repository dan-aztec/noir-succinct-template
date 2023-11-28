#!/bin/bash

# Read input from output.txt
input=$(cat output.txt)

# Remove the brackets and split the input into an array
IFS=', ' read -r -a array <<< "${input//[\[\]]/}"

# Concatenate the values without '0x'
output=""
for i in "${array[@]}"
do
    output+="${i//0x/}"
done

# Prepend '0x' to the final output
output="0x$output"

# Print directory contents and current path for debugging
echo -e $(ls)
echo -e $(pwd)
echo -e $(ls ..)

# Read the first line from circuits/proofs/circuits.proof
proof=$(head -n 1 proofs/circuits.proof)

# Prepend '0x' to the proof
proof="0x$proof"

# Write to output.json
echo -e "{\"output\": \"$output\", \n\"proof\": \"$proof\"}" > output.json
