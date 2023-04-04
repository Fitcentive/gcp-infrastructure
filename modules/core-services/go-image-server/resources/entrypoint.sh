#!/bin/sh
args=$@
set -e
echo Mount: "$MOUNT"
echo Bucket: "$BUCKET"
echo $GOOGLE_APPLICATION_CREDENTIALS > /usr/local/bin/key.json
export GOOGLE_APPLICATION_CREDENTIALS="/usr/local/bin/key.json"
mkdir -p $MOUNT

# See https://github.com/GoogleCloudPlatform/gcsfuse/blob/master/docs/semantics.md#files-and-directories on option --implicit-dirs
gcsfuse --implicit-dirs $BUCKET $MOUNT
app $args 2>&1