## Splice User Auth

Repo to tests user auth for Splice using Rspec, Capybara and Selenium WebDriver.

## Setup

* `git clone <repository-url>` this repository
* change into the new directory
* run `bundle install`
* run `rspec`

## Environments

Can be run in two different environments, staging and production using following:

* run `SERVER=staging rspec` for staging (https://staging.splice.com)
* run `SERVER=production rspec` for production (https://splice.com)

## Configuration

* Make sure you have Firefox installed:
  https://www.mozilla.org/en-US/firefox/new/

* If you already have Firefox installed, make sure you have the latest version:
  https://support.mozilla.org/en-US/kb/update-firefox-latest-version

* Running this test currently creates actual accounts on Splice so you might want to clean them up after running!
