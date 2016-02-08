# GOV.UK Gem Security Checker

This wraps the [`bundler-audit`](https://github.com/rubysec/bundler-audit/) gem to allow checking
specific Bundler lockfiles.

## Usage

Install the gem:

```
gem install govuk_security_audit
```

Update the Ruby Advisory Database:

```
govuk_security_audit update
```

Check the current directory:

```
govuk_security_audit check
```

Check another directory:

```
govuk_security_audit check ~/govuk/whitehall
```

Check a specific Gemfile.lock:

```
govuk_security_audit check /tmp/whitehall-gemfile.lock
```

Check a repo on Github:

```
govuk_security_audit github alphagov whitehall
```

Check a specific branch on Github:

```
govuk_security_audit github alphagov whitehall upgrade-rails
```

Checks but ignores specific vulnerabilities

```
govuk_security_audit check ~/govuk/whitehall --ignore OSVDB-131677 advisory
```
