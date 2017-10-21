Tyme2 Daily Standup Report
===============================================================================
> Generate a morning standup report from [Tyme2][tyme2] using AppleScript

The applescript fetches yesterdays work from [Tyme2][tyme2] and returns it in
a format ready for a Slack standup channel. On Monday, it will fetch all tasks
over the weekend as well.

## Quick start

Add the `bin` folder to your path and then run `standup`.

```bash
export PATH="/Users/craig/Projects/tyme2-standup/bin:$PATH"
```

This will fetch tasks from your previous day (with special weekend handling) and
will prompt you for todays tasks. Press enter to stop entering new tasks. It
will then prompt you about any blockers you're experiencing. Press enter to have
`none`. Once you've finished with the prompts, the morning standup report will
be in your clipboard and ready to share.

## Development

* Open the `Script Editor` application in OSX and open the
  `daily-standup.applescript` file.
* Drag the `Tyme2` application icon onto the `Script Editor` icon in the dock
  so that you can see the API that the app offers. Also check the reference at
  [Tyme2 Scripting](https://www.tyme-app.com/scripting2/)
* Edit the file
* Choose `File > Export...` and then choose the `bin/daily-standup.scpt` file
  and be sure to change the *File Format* to `Script`
* -*OR*-
* Run the `compile` script found in this repo

[tyme2]: http://tyme-app.com/
