#!/bin/sh

cd "$(dirname "$(gem which constancy)")" && cd .. || exit $?

apk add --no-cache git || exit $?

for patch_file in /tmp/patches/*.patch
do
  echo "applying patch $patch_file" &&
  git apply "$patch_file" || exit $?
done

apk del --no-cache git
