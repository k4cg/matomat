DESCRIPTION:
============

The matomat is a mostly drunken coded perl script to manage the beverage billing
at the K4CG (http://www.k4cg.org/).



REQUIREMENTS:
=============

- Perl 
- SQLite
- festival (for the t2s feature)

Perl modules:
- DBI
- Config::Simple
- Text::FIGlet
- Digest::SHA
- IO::Prompter (Version: 0.002000)
- Term::ReadKey
- Module::Load
- IO::Select
- IPC::Open3

Install missing modules using the following command

> sudo perl -MCPAN -e "install MODULE_NAME"

For Debian (Wheezy/Jessie) use:
> apt-get install perl sqlite3 festival libconfig-simple-perl libio-prompter-perl libdbi-perl libdbd-sqlite3-perl

> perl -MCPAN -e "install Text::FIGlet"

(For this you need at least `make` and a C compiler, so maybe install `build-essential`, too)

INSTALL:
========

After reading and setting the variables in the `install.sh` script, run it, to create the DB and install the files.

Default user is *admin* with password *matomat*.

Creating the matomat.db in /var/matomat/ manually:

> sqlite3 /var/matomat/matomat.db "CREATE TABLE user (userid INTEGER PRIMARY KEY, username TEXT UNIQUE, pw_hash TEXT, privs INT, credits INT);"
> sqlite3 /var/matomat/matomat.db "INSERT INTO user  (username, pw_hash, pw_change, rfid_id, privs, credits) VALUES ('admin','$whbMBT8HnaP934ck40F5NBP11ToG2obQGzrY8FXSDq5mhRJioscGkgt8EuEgMKlSXCX1GHLieT3nDWj9pW2ICGlZFBzV6AVABD5vkaGjfvBHxzaWEUGPifuUQYESfwWu1$qNqasadPwrJOUZtukd/dnM6uDyDoBq1C20Ym26SN71PgbC7Jy6xjaTX2ceZ1bN6VBujXSqdsebZrN7yU2qQGfw',0,1000,1,0);"
> sqlite3 /var/matomat/matomat.db "CREATE TABLE drinks (drinkid INTEGER PRIMARY KEY, name TEXT UNIQUE, price INT, active INT,fixed INT,t2s TEXT);"
> sqlite3 /var/matomat/matomat.db "CREATE TABLE plugins (name TXT UNIQUE, filename TXT UNIQUE, active INT);"

Login with the admin user, change the password, add some drinks and users.

AUTHORS:
========

Nikolas Sotiriu (lofi)
lofi@sotiriu.de
http://sotiriu.de

Simon (blarz)
simon@blarzwurst.de


LICENSE:
========

"THE BEER-WARE LICENSE" (Revision 42):
lofi and blarz wrote this code. As long as you retain this notice you
can do whatever you want with this stuff. If we meet some day, and you think
this stuff is worth it, you can buy us a beer in return. 


