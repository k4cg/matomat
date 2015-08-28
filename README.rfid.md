RFID REQUIREMENTS
=================

Hardware:
At the moment we're using a Touchatag NFC Reader

libnfc:
- sudo apt-get install libusb-dev libpcsclite-dev pkg-config
- wget https://github.com/nfc-tools/libnfc/releases/download/libnfc-1.5.0/libnfc-1.5.0.tar.gz
- ./configure
- make
- sudo make install

pcscd:
- http://www.libnfc.org/documentation/installation#debian_ubuntu
- sudo apt-get install libusb-0.1-4 libpcsclite1 libccid pcscd
- /etc/init.d/dbus start
- /etc/init.d/hal start
- /etc/init.d/pcscd start

Sadly you need hal and dbus to be able to talk to the reader
(and I always forget to start them...)

reader binary:
- cd reader
- make
- cp reader /var/matomat/reader
