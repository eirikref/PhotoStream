Simple PhotoStream Syncing
==========================

I love being able to automatically sync photos taken with my iPhone to
my MacBook Air using PhotoStreams, but I'm just not able to get
comfortable with iPhoto.

I'm never sure what has been copied when and where, and I'm never
certain if files are safely stored on my Mac or if they will disappear
once they are too old or I push too many new photos to my PhotoStream.

Also, I'm not very fond of iPhoto storing everything inside an
internal database instead of simply using folders that I can access
with any tool (Finder, through the terminal, etc.)

So this is a simple shell script that copies all new files from my
PhotoStream and to a separate folder. I have chosen to run it as a
cronjob ever five minutes in order to automate the process.

General Overview
----------------
* Have syncing of my PhotoStream enabled
* Copy files from the internal PhotoStream folder to my own folder
* Do the above step automatically
* Don't copy files older than the last time I synced
