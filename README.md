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

- TODO: authorize host key...

- TODO: revoke host key...

- Download remote `.ssh/authorized_keys` file and extract public keys:

        ./fetch.sh host...

- TODO: push host...

- Extract keys from an `authorized_keys` file to separate files

        ./extract-keys.sh file...


