#! /usr/bin/env bash

usage="hist [-adcrmh] [-np][argument]\n-- program to save specific project history in a file called tips.txt \n\t-a --activate: Start the recording and signified by '•' symbol
\n\t-d --deactivate: Stops the recording \n\t-c --clear: Clear unwanted variables (man,ls,echo...)  \n\t-r --refresh: refresh file
\n\t-m --message: Add comment to the previous saved line \n\t-n --name: Input specific name for your output file \n\t-p --path: Input specific path (Optionnal; Default '.') \n\t-h --help: Display help "
status=""
root=$(pwd)'/'
file=$root'tips.txt'

if [ "$#" -eq  "0" ]
   then
     echo "Error: no argument supplied"
     echo -e $usage
     return 1
fi


click=0
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --activate|-a)
    status=1
    shift
    ;;
    --deactivate|-d)
    status=0
    shift
    ;;
    --clear|-c)
    status=2
    shift
    ;;
    --refresh|-r)
    status=3
    shift
    ;;
    --refresh|-R)
    status=5
    shift
    ;;
    --message|-m)
    status=4
    shift
    ;;
    --path|-p)
    click=1
    p=1
    echo ">>> Path supplied: $2"
    path="$2"
    if [ "${path: -1}" != '/' ]
    then
      path+='/'
    fi
    shift
    shift
    ;;
    --name|-n)
    click=1
    n=1
    echo ">>> Project name: $2"
    project="$2"
    shift
    shift
    ;;
    --help|-h)
    echo -e $usage
    return 1
    ;;
    #*)
    #echo ">>> Path supplied: $key"
    #project="$key"
    #click=1
    #n=1
    #shift
    #;;
esac
done
if [ "$click" == 1 ]  && [ "$p" == 1 ]  && [ "$n" == 1 ]
  then
    base=$(basename $file) #tips.txt
    file=$root$path #~/.../
    #filename=$(basename -- "$file")#tips.txt
    extension="${base##*.}" #txt
    filename_base="${base%.*}" #tips
    filename_base+='_'
    project+='.' #project.
    file=$file$filename_base$project$extension
    echo "$file"
    unset project
elif [ "$click" == 1 ]  && [ "$p" == 1 ]
  then
    base=$(basename $file)
    file=$root$path$base
    echo "$file"
    status=1
elif [ "$click" == 1 ]  && [ "$n" == 1 ]
  then
    filename=$(basename -- "$file") #tips.txt
    extension="${filename##*.}" #txt
    filename_base="${filename%.*}" #tips
    filename_base+='_' #tips_
    project+='.' #project.
    file=$root$filename_base$project$extension #~/tips_project.txt
    echo "$file"
    status=1
    unset path
fi
if [ "$status" == 1 ]
  then
    if [ "${PS1: -2}" == '• ' ]
    then
      echo "Error: Listener already on"
      return 1
    fi

    unset n
    unset p
    unset click


    export PS1=${PS1}'• '
    #export HISTFILE=$file
    stamp_hours='#######Done on: '$(date +%d-%b-%H_%M)
    echo -e $'\n'$stamp_hours$'\n' >> $file
  #Ignore='/ls*/d; /exit/d; /pwd/d; /clear/d; /cd*/d; /man*/d; /more*/d; /less*/d; /head*/d; /tail*/d; /nano*/d; /open*/d; /source*/d'
  #PROMPT_COMMAND='if history | tail -1 | grep -q 'cat\|ls\|echo'; then  echo "matched"; fi'
  PROMPT_COMMAND='history | tail -1 | cut -c 8- >> "$file"'
elif [ "$status" == 2 ]
  then
    echo 'clearing unwanted history'
    #remove commands and duplicates
    sed -i.bak -e '/^less/d;/^ls/d;/^man/d;/^cat/d;/^more/d;/^clear/d;/^echo/d;/^help/d;/^hist.sh.*/d;/^test/d;/^mkdir/d;/^cp/d;/^mv/d;/^rm/d;/^atom/d;/^tldr/d;$!N; /^\(.*\)\n\1$/!P; D' $file
elif [ "$status" == 3 ]
  then
    echo 'clearing file'
    > $file
elif [ "$status" == 4 ]
   then
    echo add a comment to $file
    read varname
    echo \#$varname >> $file
elif [ "$status" == 0 ]
  then
    export PS1=$(echo ${PS1} | sed 's/.\{1\}$//')
    #export HISTFILE=$HOME'/.bash_history'
    PROMPT_COMMAND=update_terminal_cwd
fi
