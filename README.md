Tyme2 Daily Standup Report
===============================================================================
> Generating a standup report from my Tyme2 application using AppleScript

The applescript fetches yesterdays work from [Tyme2][tyme2] and returns it in
a format ready for my Slack standup channel. On Monday, it will fetch all tasks
over the weekend as well.

The script uses `log` to print the message to the terminal, and returns the
content as well so that it may be copied to the clipboard with osx `pbcopy`.
Use the supplied `bin/standup`.

[tyme2]: http://tyme-app.com/
