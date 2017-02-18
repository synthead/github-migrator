[![Build Status](https://travis-ci.org/synthead/github-migrator.svg?branch=master)](https://travis-ci.org/synthead/github-migrator)

## Overview

github-migrator is a tool for migrating Bitbucket issues into GitHub as GitHub issues.  It is written in Ruby and leverages the most excellent [github\_api](https://github.com/piotrmurach/github) and [bitbucket\_rest\_api](https://github.com/bitbucket-rest-api/bitbucket) gems.

## Setting up your environment

Before you get started, you must have Ruby installed.  Here's some [helpful documentation on how to install Ruby](https://www.ruby-lang.org/en/documentation/installation/).  Next, you'll need to install some gems.  This project leverages [Bundler](http://bundler.io/) for its gem dependencies, so this is super easy:

```shell
$ gem install bundler
$ bundle install
```

That's it!  We're all set up.

## Usage

github-migrator will run with no configuration or options!  It attempts to read `config/issue_handlers.yml` first, parses command-line options second, and asks you for whatever it doesn't have last.  So go ahead and just run it!

```shell
$ ./github-migrator
Bitbucket repository to read issues from:
```

If you're curious about those options, `./github-migrator --help` brings up a helpful helpy page with its options:

```
$ ./github-migrator --help
Usage: github-migrator [options]
        --bitbucket-repo REPOSITORY  Bitbucket repository to read issues from
        --bitbucket-login LOGIN      Bitbucket login
        --github-repo REPOSITORY     GitHub repository to write issues to
        --github-username USERNAME   GitHub username
```

Please note that tokens and passwords cannot be passed via command line options!  This is a bad idea for multiple reasons and is not supported.  Momma says!  To store complete credentials and avoid being prompted, take a gander at [the Configuration section](#configuration) to store this data in `config/issue_handlers.yml`.

## Configuration

A configuration file is optional, and all of its settings are optional as well!  Set what you'd like, and you'll be kindly prompted for any missing settings.  Handy!  Want to use one?  Great!  First, let's copy [the `config/issue_handlers.yml.example` file](https://github.com/synthead/github-migrator/blob/master/config/issue_handlers.yml.example) to `config/issue_handlers.yml` like so:

```shell
cp config/issue_handlers.yml.example config/issue_handlers.yml
```

Now, open `config/issue_handlers.yml` with your very favorite text editor and configure away.  The file is self-documented, so have at it.

By using a configuration file, you can leverage all of the authentication methods supported by Bitbucket and GitHub.  To date, for both services, this includes OAuth tokens, client IDs and secrets, and good 'ol basic authentication.

Also, please note that command line options always override the settings in this configuration file.  This means that a default setting can be made and later overridden by a command line option if it's useful to you.  If that's not useful, well... don't mention it or you might hurt its feelings.

## Future development

As of right now, only Bitbucket is supported.  github-migrator was written with modularity in mind, however, so adding support for more endpoints should be as easy as adding a file to [`lib/issue_handlers/`](https://github.com/synthead/github-migrator/tree/master/lib/issue_handlers) and tweaking [`github-migrator`](https://github.com/synthead/github-migrator/blob/master/github-migrator) to use it.  [Unit tests](https://github.com/synthead/github-migrator/tree/master/spec) and [example configs](https://github.com/synthead/github-migrator/tree/master/config) to match would be handy as well!

Also, this tool could easily be put into a gem so it can be used in other projects like a GTK+ front-end, or even fronted by a webserver (ahem, GitHub Enterprise admin pages, cough cough).  The framework itself could be a "base" gem (github-migrator), and the endpoints could be abstracted into "support" gems to provide specific functionality (github-migrator-bitbucket).
