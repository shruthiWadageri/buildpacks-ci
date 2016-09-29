#/bin/bash -l
set -e

DOMAIN_NAME="${DOMAIN_NAME:-cf-app.com}"

pushd cflinuxfs2-rootfs-release
  export BUNDLE_GEMFILE=cf.Gemfile
  bundle install --jobs=$(nproc) --no-cache

  bundle exec buildpack-build buildpack-build cf_spec --host=$DEPLOYMENT_NAME.$DOMAIN_NAME --no-build --no-upload
popd
