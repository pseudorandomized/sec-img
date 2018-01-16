# sec-img: An easy secure drive image high-level utility

## Overview
Sec-img is a bash script to create, mount and unmount quickly and easily a secure image file.

## How it works
Sec-img uses LUKS encryption to secure the image file, linux losetup to use the image file as a loop device and mount it, exactly as a USB stick or an external hard drive.
It will use by default ext4 file system for your disk image. If you want something else, please change the script code line ?? to the proper command.

```
sec-img needs the package cryptsetup to work properly. If you don't have it, it will ask you to install it.
```

## How to run it

You can either:
- Run the script as a program, eg type `./sec-img <COMMANDS>`
- Use it as a program, by copying it to /usr/bin or /usr/sbin, or by creating a soft link to it.

## How to use it

### Create and Format a new encrypted image file
- Type `sec-img -f <PATH-TO-IMAGE>` (e.g. sec-img -f ~/disk1.img) to create, open, format using ext4 filesystem, and finally lock the encrypted image.

### Open an encrypted disk image file
- Type `sec-img -o <PATH-TO-IMAGE>` (e.g. sec-img -o ~/disk1.img) to open an encrypted file image. System should recognize it as an external storage device (in Ubuntu,Mint distros).

### Lock an encrypted disk image file
- Type `sec-img -c <PATH-TO-IMAGE>` (e.g. sec-img -c ~/disk1.img) to lock an encrypted file image. Be sure you have unmounted (i.e. securely removed it) first.

## Author & Maintainer

Antonis Antonopoulos (pseudorandomized@gmail.com)
