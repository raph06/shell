#! /usr/bin/env bash

usage="hist [-adcCmph] [path]\n-- program to save specific project history in a file called tips.txt \n\t-a --activate: Start the recording and signified by '•' symbol
\n\t-d --deactivate: Stops the recording \n\t-c --clear: Clear unwanted variables (man,ls,echo...)  \n\t-r --refresh: refresh file
\n\t-m --message: Add comment to the previous saved line \n\t-h --help: Display help \n\t[path]: Input specific path (Optionnal; Default '.')"
status=""
file='tips.txt'

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
    --message|-m)
    status=4
    shift
    ;;
    --help|-h)
    echo -e $usage
    return 1
    ;;
    *)
    echo ">>> Path supplied: $key"
    path="$key"
    click=1
    shift
    ;;
esac
done
if [ "$click" == 1 ]
  then
    file=$path$file
    echo "$file"
fi
if [ "$status" == 1 ]
  then
    export PS1=${PS1}'• '
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
    PROMPT_COMMAND=update_terminal_cwd
fi
