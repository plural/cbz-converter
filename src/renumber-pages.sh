#!/bin/sh

set -e
set -u

FILE=$1

unzip -d renumber "${FILE}"
mv "${FILE}" "${FILE}.old"
cd renumber
mkdir new
ls *.png | sort | perl -pne 'chomp; $o = $_; $n = sprintf("page%03d.png", $. -1); $_ = qq{mv $o new/$n\n};' | sh
cd new/
zip -r ../../"${FILE}" .
cd ../../
rm -rf renumber
# rm "${FILE}.old"
