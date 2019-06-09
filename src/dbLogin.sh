#!/bin/bash
#################################
# Contacts: Arisa Kubota
# Email: arisa.kubota at cern.ch
# Date: April 2019
# Project: Local Database for Yarr
# Description: Login Database 
# Usage: ./login_db.sh [-U <user account>*]
################################

DEBUG=false

# Usage
function usage {
    cat <<EOF

Usage:
    source /db_login.sh <user account>

EOF
}

function unset_variable {
    unset name
    unset cfg
    unset account
    unset institution
    unset identity
    unset answer
    unset dbnic
    unset cnt
    unset num
    unset DEV
    unset nic
    unset address
    unset dbcfg 
}

account=$1

if [ -z ${account} ]; then
    echo "Please give user account with '-U'."
    usage
    echo "Exit ..."
    unset_variable
    return 0
fi

if [ ! -e ${HOME}/.yarr ]; then
    mkdir ${HOME}/.yarr
fi

cfg=${HOME}/.yarr/${account}_user.json
if [ ! -f ${cfg} ]; then
    echo "User Config file is not exist: ${cfg}"
    echo " "
    echo "Enter your name (<first name> <last name>) or 'exit' ... "
    read -p "> " -a answer
    while [ ${#answer[@]} == 0 ]; 
    do
        echo "Enter your name (<first name> <last name>) or 'exit' ... "
        read -p "> " -a answer
    done
    if [ ${answer[0]} == "exit" ]; then
        echo "Exit ..."
        unset_variable
        return 0
    else
        for a in ${answer[@]}; do
            name="${name#_}_${a}"
        done
    fi

    echo " "
    echo "Enter your institution (ABC Laboratory) or 'exit' ... "
    read -p "> " -a answer
    while [ ${#answer[@]} == 0 ]; 
    do
        echo "Enter your institution (ABC Laboratory) or 'exit' ... "
        read -p "> " -a answer
    done
    if [ ${answer[0]} == "exit" ]; then
        echo "Exit ..."
        unset_variable
        return 0
    else
        for a in ${answer[@]}; do
            institution="${institution#_}_${a}"
        done
    fi

    echo " "
    echo "You can set the identification keyword if you want. (e.x. nickname, SW version you use ...)"
    echo "Do you want to set the identification keyword? [y/n]"
    echo "    y => continue to set the identification keyword"
    echo "    n => set the identification keyword 'default'"
    read -p "> " -a answer
    while [ ${#answer[@]} == 0 ]; 
    do
        echo "Enter 'y' to set the identification keyword, 'n' not to set, or 'exit' to abort ... "
        read -p "> " -a answer
    done
    if [ ${answer[0]} == "exit" ]; then
        echo "Exit ..."
        unset_variable
        return 0
    fi
    if [ ${answer[0]} != "y" ]; then
        identity="default"
    else
        echo " "
        echo "Enter your identification keyword or 'cancel' ... "
        read -p "> " -a answer
        while [ ${#answer[@]} == 0 ]; 
        do
            echo "Enter your identification keyword or 'cancel' ... "
            read -p "> " -a answer
        done
        if [ ${answer[0]} == "cancel" ]; then
            identity="default"
        else
            for a in ${answer[@]}; do
                identity="${identity#_}_${a}"
            done
        fi
    fi
else
    echo "User Config file is exist: ${cfg}"
    name=`cat ${cfg}|grep 'userName'|awk -F'["]' '{print $4}'`
    institution=`cat ${cfg}|grep 'institution'|awk -F'["]' '{print $4}'`
    identity=`cat ${cfg}|grep 'userIdentity'|awk -F'["]' '{print $4}'`
fi

echo " "
echo "Logged in User Information"
echo "  Account: ${account}"
echo "  Name: ${name}"   
echo "  Institution: ${institution}"
echo "  Identity: ${identity}"
echo " "
echo "Are you sure that's correct? [y/n]"
read -p "> " answer
while [ -z ${answer} ]; 
do
    echo "Are you sure that's correct? [y/n]"
    read -p "> " answer
done

dbcfg=${HOME}/.yarr/database.json

if [ ${answer} == "y" ]; then
    if [ ! -f ${cfg} ]; then
        echo "{" > ${cfg}
        echo "    \"userName\": \"${name}\"," >> ${cfg}
        echo "    \"institution\": \"${institution}\"," >> ${cfg}
        echo "    \"userIdentity\": \"${identity}\"," >> ${cfg}
        echo "    \"dbCfg\": \"${dbcfg}\"" >> ${cfg}
        echo "}" >> ${cfg}
        echo " "
        echo "Create User Config file: ${cfg}"
    fi
    echo " "
    if "${DEBUG}"; then
        echo "export DBUSER=\"${account}\""
        echo " "
    fi
    export DBUSER=${account}
    if "${DEBUG}"; then
        echo "./bin/dbAccessor -U ${account}"
        echo " "
    fi
    ./bin/dbAccessor -U ${account}
else
    echo "Exit ..."
    echo " "
    unset_variable
    return 0
fi

echo "{" > ${dbcfg}
echo "    \"stage\": [" >> ${dbcfg}
echo "        \"Bare Module\"," >> ${dbcfg}
echo "        \"Wire Bonded\"," >> ${dbcfg}
echo "        \"Potted\"," >> ${dbcfg}
echo "        \"Final Electrical\"," >> ${dbcfg}
echo "        \"Complete\"," >> ${dbcfg}
echo "        \"Loaded\"," >> ${dbcfg}
echo "        \"Parylene\"," >> ${dbcfg}
echo "        \"Initial Electrical\"," >> ${dbcfg}
echo "        \"Thermal Cycling\"," >> ${dbcfg}
echo "        \"Flex + Bare Module Attachment\"," >> ${dbcfg}
echo "        \"Testing\"" >> ${dbcfg}
echo "    ]," >> ${dbcfg}
echo "    \"environment\": [" >> ${dbcfg}
echo "        \"vddd_voltage\"," >> ${dbcfg}
echo "        \"vddd_current\"," >> ${dbcfg}
echo "        \"vdda_voltage\"," >> ${dbcfg}
echo "        \"vdda_current\"," >> ${dbcfg}
echo "        \"hv_voltage\"," >> ${dbcfg}
echo "        \"hv_current\"," >> ${dbcfg}
echo "        \"temperature\"" >> ${dbcfg}
echo "    ]," >> ${dbcfg}
echo "    \"component\": [" >> ${dbcfg}
echo "        \"Front-end Chip\"," >> ${dbcfg}
echo "        \"Front-end Chips Wafer\"," >> ${dbcfg}
echo "        \"Hybrid\"," >> ${dbcfg}
echo "        \"Module\"," >> ${dbcfg}
echo "        \"Sensor Tile\"," >> ${dbcfg}
echo "        \"Sensor Wafer\"" >> ${dbcfg}
echo "    ]" >> ${dbcfg}
echo "}" >> ${dbcfg}
echo "Create DB Config file: ${dbcfg}"
echo " "

declare -a nic=()  
num=0
for DEV in `find /sys/devices -name net | grep -v virtual`; 
do 
    nic[${num}]=`ls --color=none ${DEV}`
    num=$(( num + 1 ))
done
if [ ${num} != 1 ]; then
    echo "Select the number before NIC name for the information of this machine."
    echo " "
    cnt=0
    while [ ${cnt} -lt ${num} ]; do
        echo ${nic[0]}
        cnt=$(( cnt + 1 ))
    done
    read -p "> " answer
    while [ -z ${answer} ]; 
    do
        echo "Select the number before NIC name for the information of this machine."
        echo " "
        read -p "> " answer
    done
    echo ${answer} | grep [^0-9] > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Please give an integral as the number before NIC name."
        echo " "
        unset_variable
        return 0
    fi
    dbnic="${nic[${answer}]}"
else
    dbnic="${nic[0]}"
fi
address=${HOME}/.yarr/address
echo `ifconfig ${dbnic} | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'` > ${address}

if "${DEBUG}"; then
    echo "./bin/dbAccessor -S"
    echo " "
fi
./bin/dbAccessor -S

unset_variable

return 0
