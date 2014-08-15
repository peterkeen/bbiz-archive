# BBiz Archive

This is currently running on http://bbiz-archive.subspace.bugsplat.info.

Each message is stored as an individual timestamped json file on disk in datestamped directories.

[Slack API Docs](https://api.slack.com)

## Developing

This is unfortunately highly tied to my deployment infrastructure. You can of course run a dev server if you like. Adjust the variables in `.env` to suit your environment. `SLACK_TOKEN` is only used for receiving webhooks, so you shouldn't have to worry about it. Message me to get a dump of the archive to play around with.

## TODO

* Search
* Make the views prettier
* Download/cache the user information and replace things like `<@U02AX5TDL>` with usernames
