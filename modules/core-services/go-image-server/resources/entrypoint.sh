#!/bin/sh
args=$@
set -e
echo Mount: "$MOUNT"
echo Bucket: "$BUCKET"
echo $GOOGLE_APPLICATION_CREDENTIALS > /usr/local/bin/key.json
export GOOGLE_APPLICATION_CREDENTIALS="/usr/local/bin/key.json"
mkdir -p $MOUNT
gcsfuse $BUCKET $MOUNT
app $args 2>&1