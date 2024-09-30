#!/bin/bash

# Function to convert string to binary
string_to_binary() {
    input="$1"
    binary_output=""
    for (( i=0; i<${#input}; i++ )); do
        # Get ASCII value of character
        ascii=$(printf "%d" "'${input:i:1}")
        # Convert ASCII to binary
        binary=$(echo "obase=2; $ascii" | bc)
        # Pad binary with leading zeros to ensure 8-bit format
        binary=$(printf "%08d" "$binary")
        binary_output+="$binary"
    done
    echo "$binary_output"
}

# Function to replace 0 with 'a' and 1 with 'A'
convert_binary_to_aA() {
    binary_input="$1"
    modified_binary=$(echo "$binary_input" | tr '01' 'aA')
    echo "$modified_binary"
}

# Function to convert "aA" stream back to binary
convert_aA_to_binary() {
    aA_input="$1"
    binary_output=$(echo "$aA_input" | tr 'aA' '01')
    echo "$binary_output"
}

# Function to convert binary back to ASCII text
binary_to_string() {
    binary_input="$1"
    text_output=""
    # Loop through binary input 8 bits at a time
    for (( i=0; i<${#binary_input}; i+=8 )); do
        byte="${binary_input:i:8}"
        # Convert binary to decimal, then to ASCII
        ascii=$(echo "$((2#$byte))")
        char=$(printf "\\$(printf '%03o' "$ascii")")
        text_output+="$char"
    done
    echo "$text_output"
}

# Main program
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: yell.bash [OPTION] [TEXT]"
    echo "Encode or decode a given text."
    echo
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"    
    echo "  -d, --decode  Decode the given encoded text"
    echo
    echo "Examples:"
    echo "  yell.bash 'test'                                Encode the parameter, returns 'aAAAaAaaaAAaaAaAaAAAaaAAaAAAaAaa'"
    echo "  yell.bash -d 'aAAAaAaaaAAaaAaAaAAAaaAAaAAAaAaa' Decode the parameter, returns 'test'"
    exit 0
fi

if [[ "$1" == "-d" || "$1" == "--decode" ]]; then
    if [[ -z "$2" ]]; then
        echo "Please provide a text to decode. (Try --help for more information.)"
        exit 1
    fi
    # Decode mode
    aA_stream="$2"
    binary_stream=$(convert_aA_to_binary "$aA_stream")
    decoded_text=$(binary_to_string "$binary_stream")
    echo $decoded_text
else
    if [[ -z "$1" ]]; then
        echo "Please provide a sentence to encode. (Try --help for more information.)"
        exit 1
    fi
    # Encode mode
    sentence="$1"
    binary_representation=$(string_to_binary "$sentence")
    final_output=$(convert_binary_to_aA "$binary_representation")
    echo "$final_output"
fi
