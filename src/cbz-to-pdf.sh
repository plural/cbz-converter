#!/bin/bash

set -e
set -u

INPUT_GLOB=$1
DPI=${2:-192}

#echo "Activating virtualenv..."
#set +o nounset
#source ~/src/img2pdf/bin/activate
#set -o nounset

for INPUT_FILE in "${INPUT_GLOB}"
do
	DIR=`dirname "${INPUT_FILE}"`
	OUTPUT_FILE=`basename "${INPUT_FILE}" .cbz`.pdf
	TMP_DIR=.tmp-convert-cbz-to-pdf-`date +%s`

	unzip -d ${TMP_DIR} "${INPUT_FILE}"
	ls -lh ${TMP_DIR}

	echo "Setting specific DPI metadata in the page files."
	set +e
	ls ${TMP_DIR}/*.jpg 2>/dev/null
	if [ $? -eq 0 ]
	then
		echo "JPEGS"
		for FILE in `ls ${TMP_DIR}/*.jpg`
		do
		  convert -density ${DPI} -units pixelsperinch ${FILE} ${FILE}.dpiset
		done
	else
		echo "PNGS"
		for FILE in `ls ${TMP_DIR}/*.png`
		do
		  convert -background white -alpha remove -alpha off -density ${DPI} -units pixelsperinch ${FILE} ${FILE}.dpiset
		done
	fi
	set -e

	echo "Producing PDF for ${OUTPUT_FILE}"
	img2pdf `ls ${TMP_DIR}/*.dpiset | sort` -o "${DIR}"/"${OUTPUT_FILE}"

	echo "Cleaning up for ${INPUT_FILE}..."
	rm -rf ${TMP_DIR}

	echo "Done with ${INPUT_FILE}!"
	ls -lh "${DIR}"/"${OUTPUT_FILE}"
done

echo 'All done!'
