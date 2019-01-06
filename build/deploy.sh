#!/usr/bin/env bash

GETH_ARCHIVE_NAME="multi-geth-$TRAVIS_OS_NAME"
zip -j "$GETH_ARCHIVE_NAME.zip" build/bin/geth

shasum -a 256 $GETH_ARCHIVE_NAME.zip
shasum -a 256 $GETH_ARCHIVE_NAME.zip > $GETH_ARCHIVE_NAME.zip.sha256

ALLTOOLS_ARCHIVE_NAME="multi-geth-alltools-$TRAVIS_OS_NAME"
zip -j "$ALLTOOLS_ARCHIVE_NAME.zip" build/bin/*

shasum -a 256 $ALLTOOLS_ARCHIVE_NAME.zip
shasum -a 256 $ALLTOOLS_ARCHIVE_NAME.zip > $ALLTOOLS_ARCHIVE_NAME.zip.sha256

ALLTOOLS_SHAS_FILE="$ALLTOOLS_ARCHIVE_NAME-sha256s.txt"
for f in build/bin/*; do
	shasum -a 256 "$f"
done | while read -r sum p; do
	line="$sum ${p##*/}"
	echo "$line" | tee -a "$ALLTOOLS_SHAS_FILE"
done

export ALLTOOLS_SHAS_SHA=$(shasum -a 256 "$ALLTOOLS_SHAS_FILE") # one sha to bind them...
echo "$ALLTOOLS_SHAS_SHA" | tee "$ALLTOOLS_SHAS_SHA.sha256"
