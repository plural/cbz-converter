#!/bin/bash

set -e
set -u

for EXT in cbz pdf
do
for FILE in *.${EXT}
do
  NEW_FILE=$(echo $FILE | perl -pne 'chomp; my $ext = ""; if (s/(^.*)\.(\w+)$/$1/) { $ext = $2; }; s/\.//g; s/#//g; s#[,\(\)]##g;  s#--#-#g; s#\+##g; s#-(\d)$#-0$1#; s#-+#-#g; $_ = qq{$_.$ext\n}')
  NEW_FILE=$(echo $NEW_FILE | perl -pne "s#'##g")
  if [[ "${FILE}" = "${NEW_FILE}" ]]
  then
    echo "👍 $FILE is good."
  else
    echo "❌ ${FILE}" "${NEW_FILE}"
    mv "${FILE}" "${NEW_FILE}"
  fi
done
done
