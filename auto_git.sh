#!/bin/env bash

  if [ $# -ne 2 ]; then
      echo "usage:"
      echo $0"  server_path  repository_path"
      exit
  fi

  if [ -e $1"/HEAD" ]; then
      server_path=$1
  else
      echo $1" is not a git repository server!!!"
      exit
  fi

  if [ -d $2"/.git" ]; then
      repository_path=$2
  else
      echo $2" is not a git repository"
      exit
  fi

  echo "You sould put your ssh public key to "
  echo "/home/git/.ssh/authorized_key"

  g_file_date_old=''

  gitPull(){
      pathOld=`pwd`
      cd $1
      git pull
      cd $pathOld
      echo "git push success!"
  }

  compareFileDate(){
      dateOld=$1
      dateNew=`stat -c %Y $2`
      if [ $dateOld != $dateNew ]; then
          gitPull $3
      fi
      g_file_date_old=$dateNew
  }


  cd $repository_path

  file_date_old=`stat -c %Y $server_path`
  gitPull $repository_path
  while :
  do
      compareFileDate $file_date_old $server_path $repository_path
      file_date_old=$g_file_date_old
      sleep 3
  done

