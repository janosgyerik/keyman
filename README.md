Key Manager
===========
Scripts to manage SSH key authorizations on remote servers.


Purpose
-------
I have several remote SSH accounts and I need a way to manage
the authorized keys from time to time, for example:

- Add the key of a friend joining a project
- Change the key of a friend (revoke old, add new)
- View all the authorizations easily at once


Commands
--------
All commands accept `-h` or `--help` flag to print a help message.

- Download remote `.ssh/authorized_keys` file and extract public keys:

        ./fetch.sh host...

- Update `authorized_keys` on remote host based on local authorization info:

        ./push.sh host...

- Extract keys from an `authorized_keys` file to separate files:

        ./extract-keys.sh file...

    You should not need to use this script directly.


Notes
-----
Authorization information is stored in the directory `./private` and
is set to be ignored by Git. You may want to convert that directory
to a Git repository and store it on your private server.


