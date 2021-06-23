#!/bin/bash

set -e
set -u

DIR=$1

#find ${DIR} -name '*.cbz' -print0 | while read -d'' FILE
for FILE in "${DIR}"/*.cbz
do
#  echo "${FILE}"
  NUM_PAGES=$(unzip -l "${FILE}" | grep -i -E "(jpg|png)$" | wc -l)
  LAST_PAGE=$(unzip -l "${FILE}" | grep -i -E "(jpg|png)$" | perl -pne 's/^.*?(\d+)\.(jpg|png)$/$1/i' | sort | tail -n 1)
  SKIPPED=$(unzip -l "${FILE}" | grep -i -E "(jpg|png)$" | perl -pne 's/^.*?(\d+)\.(jpg|png)$/$1/i' | sort | perl -ne 'BEGIN { $l = 0; $skipped = false; } chomp; $x = int($_); if (($x - $l) > 1) { $skipped = true; } $l = $x; END { printf("skipped=%s\n", $skipped) }')

  echo "${FILE}: num=${NUM_PAGES} / last=${LAST_PAGE} / ${SKIPPED}"
done
