PUTRID - A Ruby rewrite of RANCID with git support

Connects to listed Cisco network devices (SSH first, Telnet fallback), runs a number of commands, and commits the output to Git.

I know, this should really be in a gem. As the Bosstones so succintly put, 'Someday, I Suppose...'

Installation instructions

1. Ensure that ruby >=1.9 is installed on the system and set as default
2. Install the following gems: highline, net-ssh, net-telnet (included in the Gemfile)
3. Edit the /cron/cronfile text and insert it into root's crontab

Notes:
This code makes the git commit/push against the same repo from which the code is cloned.
Some of the logic that determines network device type relies on the banner/MOTD/prompt to be fairly vanilla. If you've horsed around with yours, tread carefully.
