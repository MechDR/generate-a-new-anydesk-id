# Generate a new AnyDesk ID

This script generates a new AnyDesk ID (Windows only for now, I'm working on the Linux one) by deleting the directories where AnyDesk stores it's ID data (`C:\ProgramData\AnyDesk` in Windows, `/root/.anydesk` and/or `/etc/anydesk` in Linux). It also deletes all the AnyDesk user profiles from local users, since the AnyDesk ID is also copied in the user profiles (`C:\Users\<UserName>\AppData\Roaming\AnyDesk` in Windows, `/home/<username>/.anydesk` in Linux).

Some people might call this method destructive (sice it destroys all AnyDesk settings, including history, recent sessions, etc.), but I call it failsafe. Yes, the AnyDesk ID is stored in `system.conf` (located in the AnyDesk system wide directory, `C:\ProgramData\AnyDesk` for Windows, `/root/.anydesk` and/or `/etc/anydesk` for Linux), but I've had cases where I've deleted the system.conf file and the ID just wouldn't change. The "nuke everything" method has proven to be most effective. Yes, it deletes all of the settings you might have changed in AnyDesk from the defaults, but at least you get a fresh new ID.

You have to run the script as an administrator in Windows (right click --> `Run as administrator`) or as root in Linux (first you need to give the script execution privileges, `chmod +x /path/to/script`).
