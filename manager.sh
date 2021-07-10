#!/bin/bash

green=0
count1=0
count2=0
userarray=(`ps -ef | awk '$1 != "UID" {print $1}' | sort | uniq`)
usernumber=$((${#userarray[@]}-1))
plus=0

while [ true ]
do
    cmdarray=(`ps -ef | grep "${userarray[count1]}" | awk '{print $8}' | awk '{i++; s[i]=$0} END { for(i; i>0; i--) print s[i] }'`)
    stimearray=(`ps -ef | grep "${userarray[count1]}" | awk '{print $5}' | awk '{i++; s[i]=$0} END { for(i; i>0; i--) print s[i] }'`)
    pidarray=(`ps -ef | grep "${userarray[count1]}" | awk '{print $2}' | awk '{i++; s[i]=$0} END { for(i; i>0; i--) print s[i] }'`)
    psnumber=$((${#cmdarray[@]}-1))
    bgcheck=(`jobs -p`)
    groundarray=()

    if [ ${#bgcheck[@]} -eq 0 ]; then
        for i in ${pidarray[@]}
        do
            groundarray+=("F")
        done
    else
        for i in ${pidarray[@]}
        do
            for j in ${bgcheck[@]}
            do
                if [ "$i" = "$j" ]; then
                    groundarray+=("B")
                else
                    groundarray+=("F")
                fi
            done
        done
    fi

    clear

    echo "______                     _    _"
    echo "| ___ \                   | |  (_)"
    echo "| |_/ / _ __   __ _   ___ | |_  _   ___   ___"
    echo "|  __/ |  __| / _  | / __|| __|| | / __| / _ \ "
    echo "| |    | |   | (_| || (__ | |_ | || (__ |  __/"
    echo "\_|    |_|    \__,_| \___| \__||_| \___| \___|"
    echo "                                                              "
    echo "(_)       | |    (_)"
    echo " _  _ __  | |     _  _ __   _   _ __  __"
    echo "| ||  _ \ | |    | ||  _ \ | | | |\ \/ /"
    echo "| || | | || |____| || | | || |_| | >  <"
    echo "|_||_| |_|\_____/|_||_| |_| \__,_|/_/\_\ "
    echo "                                                                "
    echo ""
    echo "`date +"%r"`"
    echo ""
    if [ $green -eq 0 ]; then
        echo "-NAME-----------------CMD--------------------PID-----STIME-----"
        for (( i=0; i<20; i++ ))
        do
            if [ $i -eq $count1 ]; then
                printf "|[41m%20.20s[0m|%-2s%-20.20s|%7.7s|%9.9s|\n" "${userarray[i]}" "${groundarray[i]}" "${cmdarray[i]}" "${pidarray[i]}" "${stimearray[i]}"
            else
                printf "|%20.20s|%-2s%-20.20s|%7.7s|%9.9s|\n" "${userarray[i]}" "${groundarray[i]}" "${cmdarray[i]}" "${pidarray[i]}" "${stimearray[i]}"
            fi
        done
        echo "---------------------------------------------------------------"
    elif [ $green -eq 1 ]; then
        if [ $plus -eq 0 ]; then
            echo "-NAME-----------------CMD--------------------PID-----STIME-----"
            for (( i=0; i<20; i++ ))
            do
                if [ $i -eq $count1 ] && [ $i -eq $count2 ]; then
                    printf "|[41m%20.20s[0m|[42m%-2s%-20.20s|%7.7s|%9.9s[0m|\n" "${userarray[i]}" "${groundarray[i]}" "${cmdarray[i]}" "${pidarray[i]}" "${stimearray[i]}"
                elif [ $i -eq $count1 ]; then
                    printf "|[41m%20.20s[0m|%-2s%-20.20s|%7.7s|%9.9s|\n" "${userarray[i]}" "${groundarray[i]}" "${cmdarray[i]}" "${pidarray[i]}" "${stimearray[i]}"
                elif [ $i -eq $count2 ]; then
                    printf "|%20.20s|[42m%-2s%-20.20s|%7.7s|%9.9s[0m|\n" "${userarray[i]}" "${groundarray[i]}" "${cmdarray[i]}" "${pidarray[i]}" "${stimearray[i]}"
                else
                    printf "|%20.20s|%-2s%-20.20s|%7.7s|%9.9s|\n" "${userarray[i]}" "${groundarray[i]}" "${cmdarray[i]}" "${pidarray[i]}" "${stimearray[i]}"
                fi
            done
            echo "---------------------------------------------------------------"
        else
            echo "-NAME-----------------CMD--------------------PID-----STIME-----"
            for (( i=0; i<20; i++ ))
            do
                fix=`expr $i + $plus`
                if [ $i -eq $count1 ] && [ $i -eq $count2 ]; then
                    printf "|[41m%20.20s[0m|[42m%-2s%-20.20s|%7.7s|%9.9s[0m|\n" "${userarray[i]}" "${groundarray[fix]}" "${cmdarray[fix]}" "${pidarray[fix]}" "${stimearray[fix]}"
                elif [ $i -eq $count1 ]; then
                    printf "|[41m%20.20s[0m|%-2s%-20.20s|%7.7s|%9.9s|\n" "${userarray[i]}" "${groundarray[fix]}" "${cmdarray[fix]}" "${pidarray[fix]}" "${stimearray[fix]}"
                elif [ $i -eq $count2 ]; then
                    printf "|%20.20s|[42m%-2s%-20.20s|%7.7s|%9.9s[0m|\n" "${userarray[i]}" "${groundarray[fix]}" "${cmdarray[fix]}" "${pidarray[fix]}" "${stimearray[fix]}"
                else
                    printf "|%20.20s|%-2s%-20.20s|%7.7s|%9.9s|\n" "${userarray[i]}" "${groundarray[fix]}" "${cmdarray[fix]}" "${pidarray[fix]}" "${stimearray[fix]}"
                fi
            done
            echo "---------------------------------------------------------------"
        fi
    fi

    echo "If you want to exit , Please Type 'q' or 'Q'"
    read -n 3 key
    if [ "$key" = "q" ] || [ "$key" = "Q" ]; then
        break
    elif [ "$key" = "[C" ]; then
        green=1
    elif [ "$key" = "[D" ]; then
        green=0
        count2=0
        plus=0
    elif [ "$key" = "[B" ]; then
        if [ $green -eq 0 ]; then
            if [ $count1 -ge $usernumber ]; then
                continue
            else
                count1=$(($count1+1))
            fi
        elif [ $green -eq 1 ]; then
            if [ $count2 -ge $psnumber ];then
                continue
            elif [ $count2 -eq 19 ]; then
                range=`expr $plus + $count2`
                if [ $range -ge $psnumber ]; then
                    continue
                else
                    plus=$(($plus+1));
                fi
            else
                count2=$(($count2+1))
            fi
        fi
    elif [ "$key" = "[A" ]; then
        if [ $green -eq 0 ]; then
            if [ $count1 -lt 1 ]; then
                continue
            else
                count1=$(($count1-1))
            fi
        elif [ $green -eq 1 ]; then
            if [ $plus -gt 0 ]; then
                plus=$(($plus-1))
            elif [ $count2 -lt 1 ]; then
                continue
            else
                count2=$(($count2-1))
            fi
        fi
    elif [ $green -eq 1 ] && [ "$key" = "" ]; then
        if [ $plus -eq 0 ]; then
            pserror1=$(kill -9 ${pidarray[count2]} 2>&1 >/dev/null)
            if [ -n "$pserror1" ]; then
            clear
            echo "You can't!"
            read -n 1 skip
            fi
        else
            n=`expr $plus + $count2`
            pserror2=$(kill -9 ${pidarray[n]} 2>&1 >/dev/null)
            if [ -n "$pserror2" ]; then
            clear
            echo "You can't!"
            read -n 1 skip
            fi
        fi
    else
        continue
    fi

done
