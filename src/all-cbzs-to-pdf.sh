#!/bin/bash

cd /comics/
/src/fix-filenames.sh

cd /
for CBZ in `ls comics/*.cbz`
do
  echo "Checking out ${CBZ}"
  PDF=${CBZ%cbz}pdf
  echo "Checking for existence of ${PDF}"
  if [[ -e "${PDF}" ]]
  then
    echo "${PDF} already exists..."
  else
    /src/cbz-to-pdf.sh ${CBZ}
  fi
done
