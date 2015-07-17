#!/bin/bash -x
set -e

rm -f Gemfile.lock
git clean -fdx
bundle install --path "${HOME}/bundles/${JOB_NAME}"

# Run against our own lockfile to test
bundle exec govuk_security_audit

if [[ -n "$PUBLISH_GEM" ]]; then
  bundle exec rake publish_gem
fi
