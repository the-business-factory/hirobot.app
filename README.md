# Hiro: A Slack App for Technical Communities

Hiro is a Slack app using [Lucky](https://luckyframework.org) and the [slack.cr](https://github.com/the-business-factory/slack.cr).

Currently, it is in beta use on the [Ruby on Rails Slack Community](https://www.rubyonrails.link/) and is providing tools to automate responses to posts, helping curate a better job board for the community.

### Setting up the project

1. [Install required dependencies](https://luckyframework.org/guides/getting-started/installing#install-required-dependencies)
1. Update database settings in `config/database.cr`
1. Run `script/setup`
1. Optional: Install overmind or foreman as a process manager
1. Optional: Run `OVERMIND_PROCFILE="Procfile.dev" overmind s` or `foreman start -f Procfile.dev` to start the app (note: since this app is running in production, you'll need to change settings to a new app to run the app locally against Slack)
1. Run `crystal spec` to run tests
1. Run `bin/ameba` to run automated code checks

### Learning Lucky

Lucky uses the [Crystal](https://crystal-lang.org) programming language. You can learn about Lucky from the [Lucky Guides](https://luckyframework.org/guides/getting-started/why-lucky).
