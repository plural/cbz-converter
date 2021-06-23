#!/bin/bash

set -e
set -u

INPUT_GLOB=$1
DPI=${2:-72}

for INPUT_FILE in `ls ${INPUT_GLOB}`
do
  echo "Starting conversion for ${INPUT_FILE}..."
  DIR=`dirname "${INPUT_FILE}"`
  OUTPUT_FILE=`basename "${INPUT_FILE}" .pdf`.cbz
  TMP_DIR=.tmp-convert-pdf-to-cbz-`date +%s`

  mkdir ${TMP_DIR}

  NUM_PAGES=$((`identify -density 2 "${INPUT_FILE}" | wc -l` + 0))
  PAGE_INDEX=$(($NUM_PAGES - 1))
  echo "${INPUT_FILE} has ${NUM_PAGES} pages and a range of [0-${PAGE_INDEX}]."

  for PAGE in `seq 0 ${PAGE_INDEX}`
  do
    echo "Converting page ${PAGE}..."
    convert -density ${DPI} "${INPUT_FILE}"[${PAGE}] ${TMP_DIR}/original-page-${PAGE}.png
  done
  ls -lh ${TMP_DIR}/
  echo "Re-numbering files in preparation for compression."
  for I in `seq ${PAGE_INDEX} -1 0`
  do
    NEW_I=$(($I + 1))
    O="${TMP_DIR}/original-page-${I}.png"
    N="${TMP_DIR}/`printf page-%03d.png ${NEW_I}`"
    mv "${O}" "${N}"
  done

  cd ${TMP_DIR}
  ls *.png | zip ../"${OUTPUT_FILE}" -@
  cd ..

  rm -rf ${TMP_DIR}
done

echo 'All done!'
