#!/bin/bash

set -el

SUFFIX="${ROOTFS_SUFFIX-}"

source=stack-s3/cflinuxfs2$SUFFIX-*.tar.gz
destination=stack-archive/cflinuxfs2$SUFFIX-`cat version/number`.tar.gz

mv $source $destination
