#!/bin/bash
# Kaif Ratani

# Function help
# Display help information about the script usage
function help {
    echo
    echo "Usage:"
    echo "  banner [OPTION]... STRING"
    echo
    echo "Options:"
    echo "  -w NUM     the w value for the banner"
    echo "  -p NUM     Adds the pd value in banner"
    echo "  -c [CHAR]  (default is asterisk) Set the border character"
    echo "  -n         print without the border"
    echo "  -h         display this help message"
    echo
    echo "Replace STRING with the string to create a banner with that string."
    echo "Created by: Kaif Ratani"
    exit 0
}

# Get the width (w) of the terminal
w=$(tput cols)

# Function for simple banner
# Create a simple banner with the specified string centered in the terminal
function de_banner {
    local string="$@"
    local slen=${#string}
    # Calculate left spacing (sl) and right spacing (sr) for centering the string
    local sl=$(( ($w - $slen) / 2 ))
    local sr=$(( $w - $sl - $slen ))

    #printing the first line of the banner 
    echo -n "+"
    for (( i=0; i<($w-2); i++ ))
    do
        echo -n "-"
    done
    echo "+"

    #printing the second line of the banner with space and text 
    echo -n "|"
    for (( i = 0; i<($sl-1); i++ ))
    do
        echo -n " "
    done
    echo -n $string
    for (( i = 0; i < ($sr-1); i++ ))
    do
        echo -n " "
    done
    echo "|"

    # printing the last line of the banner
    echo -n "+"
    for (( i=0; i<($w-2); i++ ))
    do
        echo -n "-"
    done
    echo "+"
}

# Function to create a custom banner with arguments
# Create a custom banner with the specified string and additional options
function banner {
    pd=0 #padding 
    char="-"
    while [[ ${1:0:1} == '-' ]]; do
        case "$1" in
            -w*)
                w=${1:2}
                shift
                ;;
            -p*)
                pd=${1:2}
                shift
                ;;
            -c*)
                if [[ "$1" == "-c" ]]; then
                    set -f
                    char='*'
                else
                    char="${1:2}"
                fi
                shift ;;
            -n*)
                char=" "
                shift
                ;;
            -h*)
                help
                ;;
            *)
                echo "Usage: banner [OPTION]... STRING"
                exit 0
                ;;
        esac
    done

    # all the variables are initialize for this method only 
    local string="$@"
    local slen=${#string}
    local sl=$(( ($w - $slen) / 2 ))
    local sr=$(( $w - $sl - $slen ))

    #printing the first line of banner with custiom border character 
    for (( i=0; (i<$w-1); i++ ))
    do
        echo -n $char
    done
    echo $char

    #Pinting the padding if exist 
    for (( j=0; j<$pd; j++ ))
    do
        echo -n $char
        for (( k=0; k<$w-2; k++ ))
        do
            echo -n " "
        done
        echo $char
    done

    # Printing the text 
    echo -n $char
    for (( i=0; i<($sl-1); i++ ))
    do
        echo -n " "
    done
    echo -n $string
    for (( i=0; i<($sr-1); i++ ))
    do
        echo -n " "
    done
    echo $char

    #padding after the text 
    for (( j=0; j<$pd; j++ ))
    do
        echo -n $char
        for (( k=0; k<$w-2; k++ ))
        do
            echo -n " "
        done
        echo $char
    done

    #end line of the border 
    for (( i=0; (i<$w-1); i++ ))
    do
        echo -n $char
    done
    echo $char
}

# Check if the script is called with options or just a string
# Call the appropriate banner function accordingly
if [[ ${1:0:1} == '-' ]]; then
    banner "$@"
else
    de_banner "$@"
fi
