# What is It?

cleanOFBackup stands for 'Clean OmniFocus Backup'.

[OmniFocus](http://www.omnigroup.com/products/omnifocus/) is a great personal task management program from The Omni Group. But it does have one significant flaw: there does not appear to be any way to turn off daily backups.

Once or twice a day, backups are created in '~/Documents/OmniFocus Backups' folder. This script can be used to quickly, or even automatically, remove them.

# Why I Wrote It?

With Time Machine, there is no need for those backups. And with the default 'All My Files' Finder view in Lion, those backup files (folders, actually) are downright annoying.

And since I am learning Ruby... 

# How To Use It?

After downloading cleanOFBackup.rb and making it executable, it can be run in one of the following ways:

#### cleanOFBackup.rb

Immediately delete all OmniFocus backups from '~/Documents/OmniFocus Backups' folder.

#### cleanOFBackup.rb delayed

Wait few seconds, then delete the backups from '~/Documents/OmniFocus Backups' folder.

#### cleanOFBackup.rb on

Create a Launch Agent in ~/Library/LaunchAgents. The Launch Agent will be called 'com.bartcichosz.cleanOFBackup.plist' and it will monitor the OmniFocus backup folder. When a new backup is created 'cleanOFBackup.rb delayed' will be called to remove the backup.

The 'delayed' option is used to give OmniFocus time to complete the backup.

Note that the Launch Agent will be created pointing back to the script's location at the time of using this option. If cleanOFBackup.rb is moved later, turn the automatic option off, then back on to update the Launch Agent.

#### cleanOFBackup.rb off

This option removes the Launch Agent script described above, stopping the automated removal of OmniFocus backups.

# Notes

#### Ruby Version

This script was written and tested under Ruby 1.9.2p290, under [RVM](http://beginrescueend.com/).

It *should* work under Ruby 1.8.7, which ships with Lion, but I have no way of testing it in an environment without RVM.

#### Known Issues

* If OmniFocus creates a backup when the computer is shutting down or the user is logging off, cleanOFBackup.rb script may not have enough time to delete that backup. That backup will be deleted at the later time when another backup is created.

# Questions?

If you have any questions, feel free to e-mail me at barrrt on Google's mail service or ask on Twitter ([@barrrt](https://twitter.com/#!/barrrt)).


