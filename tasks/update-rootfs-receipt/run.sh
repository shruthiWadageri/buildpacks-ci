#!/bin/bash

set -e

SUFFIX="${ROOTFS_SUFFIX-}"

cp receipt-s3/cflinuxfs2_receipt$SUFFIX-* stacks/cflinuxfs2/cflinuxfs2_receipt

pushd stacks
    version=`cat ../version/number`
    git commit -m "Commit receipt for $version" -- cflinuxfs2/cflinuxfs2_receipt
popd

rsync -a stacks/ new-stack-commit
