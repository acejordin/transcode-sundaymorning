# transcode-sundaymorning

Powershell script to convert, using HandbrakeCLI, Plex recorded episodes of CBS Sunday Morning to h.265, copy h.265 version to another machine and then delete the recorded episode

Will be run by Windows Task Scheduler on a schedule

[How to export preset json from gui for cli](https://www.truenas.com/community/threads/set-a-custom-preset-for-handbrakecli-in-freenas.58434/)

[--% (Stop Parsing command) is needed in order for powershell to correctly run handbrakecli with the necessary parameters](https://ss64.com/ps/stop-parsing.html)
nevermind that - easier way found