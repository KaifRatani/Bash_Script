#!/usr/bin/bash
# Kaif Ratani - 041076291

# Display a welcome message
echo Hello $USER
echo Today is $(date)
./banner.sh -c# Welcome to the System
echo 
echo Note that these are administrative functions that will ask for an administrator password.
echo

# Function to print actual users of the system
function print_User {
    ./banner.sh -w60 -c+ Actual Users of the System
    echo
    while IFS=":" read -r username password userid groupid user_name home shell
    do  
        if [[ "$userid" -ge 1000 && "$userid" -lt 65534 && -n $user_name ]]; then 
            echo "$username : $user_name"
        elif [[ "$userid" -ge 1000 && "$userid" -lt 65534 ]]; then 
            echo "$username :"
        fi
    done < /etc/passwd | sed 's/,,,//'
}

# Function to print user groups of the system
function print_Group {
    ./banner.sh -w60 -c+ User Groups of the System
    echo A '*' includes that the group is not a personal group 
    while IFS=":" read -r groupname x groupid x; do
        if [[ "$groupid" -ge 1000 && "$groupid" -lt 65534 ]]
        then
            match=false
            while IFS=":" read -r username password userid groupid user_name home shell 
            do
                if [[ "$groupname" == "$username" ]]
                then
                    match=true
                    break
                fi
            done < /etc/passwd 

            if $match 
            then
                echo "$groupname group"
            else
                echo "* $groupname group"
            fi
        fi
    done < <(getent group) 
}

# Function to add a user to the system
function add_User {
    read -p "Enter the user name: " username
    sudo useradd "$username"
    echo "User added with this name $username on $(date)" >> useradmin.log
}

# Function to create a welcome file for a user
function create_Wel_file {
    echo Welcome to the system "$USER! Hope you are doing well and enjoy using this program."> welcome.txt 
    username="$HOME"
    cp welcome.txt "$username/"
    if [ $? -eq 0 ]
    then 
        echo "Welcome message sent to $USER on $(date)" >> useradmin.log
        echo "User file created successfully"
    else 
        echo "Error because of User not found or copy operation failed."
    fi
}

# Function to set an account expiration date for a user
function set_exp {
    while true 
    do 
        read -p "Enter the username for which you want to change the expiry date: " username 
        read -p "Enter the expiry date (YYYY-MM-DD): " lost_date

        if date -d "$lost_date" >/dev/null 2>&1
        then
            if sudo usermod -e "$lost_date" "$username"
            then
                echo "Expiry date for $username is updated successfully to $lost_date on $(date)" >> useradmin.log
                break
            else 
                echo "Error because of invalid username"
            fi 
        else  
            echo "Error because of invalid date format. Please enter date in YYYY-MM-DD."
        fi
    done
}

# Function to delete a user from the system
function delete_User {
    read -p "Enter the username you want to delete: " username
    if id "$username" &>/dev/null
    then
        read -p "Are you sure you want to delete this user? (Y/N): " confirm
        if [[ $confirm == "Y" || $confirm == "y" ]]
        then 
            sudo userdel "$username"
            echo "Deleted $username $(date)" >> useradmin.log
            echo "Orphaned $(getent passwd "$username" | cut -d: -f6)" >> useradmin.log
        else 
            echo "User is not going to be deleted"
        fi
    else
        echo "Username $username not found"
    fi
}

# Main menu loop
while true; do
    ./banner.sh -w60 -c+ System Menu
    echo
    echo Enter your choice: 
    echo "(P)rint out a list of regular users"
    echo "(L)ist out all of the user groups"
    echo "(A)dd a new user to the system"
    echo "(C)reate a welcome file to a user's home directory"
    echo "(S)et an account expiration date for a user account"
    echo "(D)elete a user from the system"
    echo "(Q)uit the menu"
    echo
    read -rp "" choice
    echo
    case "$choice" in
        p | P) 
            print_User
            ;;
        l | L)
            print_Group
            ;;  
        a | A) 
            add_User
            ;;
        c | C)
            create_Wel_file
            ;;
        s | S)
            set_exp
            ;;
        d | D)
            delete_User
            ;;
        q | Q)
            echo goodbye
            exit 0
            ;;
    esac
    echo
    read -rp "Press enter to continue"
done
