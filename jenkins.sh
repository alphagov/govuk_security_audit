#!/bin/bash -x
set -e

rm -f Gemfile.lock
git clean -fdx
bundle install --path "${HOME}/bundles/${JOB_NAME}"

# Run against our own lockfile to test
bundle exec govuk_security_audit update
bundle exec govuk_security_audit check

# Check against rails/rails master as this should always be ahead of security Updates
# We can't check our own repo on Github as we don't commit the Gemfile.lock.
bundle exec govuk_security_audit github rails rails master

if [[ -n "$PUBLISH_GEM" ]]; then
  bundle exec rake publish_gem
fi
