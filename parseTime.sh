#!/bin/bash

awk 'BEGIN{i=0} { timeArr[i] = $0;
  if (timeArr[i] !~ "::") { 
    timeArr[i] = "0::" timeArr[i];
  }
  
  gsub("::", ":", timeArr[i]);
  if (1 == FNR) {
      N=split(timeArr[i], time1Tokens, ":");
    } else {
      N=split(timeArr[i], time2Tokens, ":");
    } 
  i++;
} END {
  minutes = time1Tokens[3] + time2Tokens[3];
  hours   = time1Tokens[2] + time2Tokens[2];
  days    = time1Tokens[1] + time2Tokens[1];

  hours  += int (minutes/60);
  minutes = minutes % 60;
  days  +=  int (hours / 24);
  hours = hours % 24;
  if (days > 1.0) { printf days "::"}

  printf hours ":"
  if (minutes < 10) {printf "0"}
  print minutes
}' $1
