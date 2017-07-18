#!/bin/bash

urlfile=$PWD/pg1514.txt
inputfile=$PWD/midsummernight.txt

function initial_setup()
{
#Try wget or curl to get the file from Web.
  wget -c http://www.gutenberg.org/cache/epub/1514/pg1514.txt
  if [[ $? -ne 0 ]]; then
    curl http://www.gutenberg.org/cache/epub/1514/pg1514.txt > $urlfile
    if [[ $? -ne 0 ]]; then
      echo "Failed to get the input file. Exiting"
      exit 1
    fi
  fi

  chmod 644 $urlfile
  sed -i 's/
//g' $urlfile
  if [[ $? -ne 0 ]]; then
    echo "Failed dos to unix conversion. Exiting script"
    exit 1
  fi

# get essential piece of the file. That is: after ACT I.
  gawk '/ACT I\./ {while(getline) print}' $urlfile > $inputfile
 
  chmod 644 $inputfile
}

function cleanup()
{
  rm -f ${urlfile}
  rm -f ${inputfile}
}

function per_char()
{
  if [[ "" = "$1" ]]; then
    echo "Empty value of character to search for."
    exit 1
  else
    export hero=$1
  fi
  echo "$1 dialogues are:"
  infile=${inputfile}

  echo "gawk '/^$hero$/ {while(length(\$0)>0) {getline; print}}' $infile" > ./run_tmp_grep.sh
  . ./run_tmp_grep.sh
  rm -f ./run_tmp_grep.sh
}

# Prints longer than five lines dialogs
function longer_lines()
{
# inputfile=$1
  egrep -v "\[" ${inputfile} | \
  gawk 'BEGIN {FS="\n";i=0;RS='\n\n'} 
              {A[i]=$0; i++}
        END   {
                for (a in A)
                {
                  n=split(A[a], arr, "\n");
                  if (n > 6)
                    print A[a] "\n"
                }
        }'
}

function helpmenu()
{
  echo "Usage:"
  echo "  -o1|-o2"
  echo ""
  echo "  -o1 NAME option to parse the dialogs of a single character (like OBERON, TITANIA, etc)"
  echo "  -o2  option to parse dialogs that are longer than 5 lines"
}


function parseInputParams()
{
  option=$1

  if [[ "$option" = "-o1" ]]; then
    initial_setup
    per_char $2
  elif [[ "$option" = "-o2" ]]; then
    initial_setup
    longer_lines
  else
    helpmenu
  fi
}

parseInputParams $@
cleanup
