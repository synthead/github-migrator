[![Build Status](https://travis-ci.org/synthead/github-migrator.svg?branch=master)](https://travis-ci.org/synthead/github-migrator)

## Overview

github-migrator is a tool for migrating Bitbucket issues into GitHub as GitHub issues.  It is written in Ruby and leverages the most excellent [github\_api](https://github.com/piotrmurach/github) and [bitbucket\_rest\_api](https://github.com/bitbucket-rest-api/bitbucket) gems.

## Setting up your environment

Before you get started, you must have a Ruby environment on your system.  If you get a Ruby version after you issue `ruby -v` on a command line, you're set.  If not, thumb through [the documentation for how to install Ruby](https://www.ruby-lang.org/en/documentation/installation/), get it installed, and swing back here when you're ready.

Next, you'll need to install some gems.  This project leverages [Bundler](http://bundler.io/) for its gem dependencies, so make sure it's installed by running `gem install bundler`.  Afterwards, run `bundle install` from the project's root directory to install all the pretty little gems.  Yes, they're pretty... don't judge!

## Configuration

Alright, so you got your environment setup.  Cool!  Now we have to configure github-migrator so it knows who to log in as and what repositories to care about.  First, let's copy [the `issue_handlers.yml.example` file](https://github.com/synthead/github-migrator/blob/master/config/issue_handlers.yml.example) to `issue_handlers.yml` like so:

```shell
cp config/issue_handlers.yml.example config/issue_handlers.yml
```

Now, open `config/issue_handlers.yml` up with your very favorite text editor and configure away.  The file is self-documented, so follow the comments to get the repository and authentication settings configured for both Bitbucket and GitHub.

## Usage

That's right... [we're there](https://www.youtube.com/watch?v=4lpUZ2Ntnlg)!  Let's get to using this thing.  Since Ruby is installed, the gems are happy, and the configs are configged, all we have to do is run it:

```shell
./github-migrator
```

While this is in action, why not head over to your configured GitHub repository and watch the issues flood in?

## Future development

As of right now, only Bitbucket is supported.  github-migrator was written with modularity in mind, however, so adding support for more endpoints should be as easy as adding a file to [`lib/issue_handlers/`](https://github.com/synthead/github-migrator/tree/master/lib/issue_handlers) and tweaking [`github-migrator`](https://github.com/synthead/github-migrator/blob/master/github-migrator) to use it.  [Unit tests](https://github.com/synthead/github-migrator/tree/master/spec) and [example configs](https://github.com/synthead/github-migrator/tree/master/config) to match would be handy as well!

Also, this tool could easily be put into a gem so it can be used in other projects like a GTK+ front-end, or even fronted by a webserver (ahem, GitHub Enterprise admin pages, cough cough).  The framework itself could be a "base" gem (github-migrator), and the endpoints could be abstracted into "support" gems to provide specific functionality (github-migrator-bitbucket).

It would also be [neat](https://www.youtube.com/watch?v=Hm3JodBR-vs) to see command line options integrated into this tool.  This way, the user could be prompted for configuration options if they aren't set.  This would also enable the tool to be ran as part of a script without having to mess with configuration files as well.
