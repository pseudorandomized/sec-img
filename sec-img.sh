#!/bin/bash

Confirm() {
  read -r -p "[y/N] " response
  case "$response" in
      [yY][eE][sS]|[yY])
          true
          ;;
      *)
          false
          ;;
  esac
}

if [ "$(whoami)" != "root" ]
  then
  echo "Please run this with sudo or as root!"
  exit
fi

if ! dpkg -s cryptsetup > /dev/null
    then
    echo "cryptsetup package isn't installed. Would you like to install it?"
    if Confirm
      then
      apt-get install cryptsetup
    fi
fi

lpd=$(losetup -f)

if [ -z "$1" ] || [ "$1" == "-h" ]
  then
    echo -e "\e[38;5;82mSec-img menu\e[0m"
    echo -e "----------------------------"
    echo -e "- Type `sec-img -f <PATH-TO-IMAGE>` (e.g. sec-img -c ~/disk1.img)"
fi

if [ "$1" == "-f" ]
  then
    if [ -z "$2" ]
      then
        echo "Please use \"sec-img -c <PATH-TO-FILE>\" to create a new image"
      else
        read -p "Set a file size (e.g 500M):" sz
        echo "Do you want to create a new encrypted $sz image file to $2?"
        if Confirm
          then
          echo -e "\e[38;5;82m--Creating image drive\e[0m"
          dd if=/dev/zero of=$2 bs=1 count=0 seek=$sz
          echo -e "\e[38;5;82m--Looping file image in $lpd\e[0m"
          losetup $lpd $2
          echo -e "\e[38;5;82m--Encrypting image drive\e[0m"
          cryptsetup -y luksFormat $lpd
          echo -e "\e[38;5;82m--Decrypting image drive\e[0m"
          cryptsetup luksOpen $lpd luksimg
          echo -e "\e[38;5;82m--Formatting image drive using ext4\e[0m"
          mkfs.ext4 /dev/mapper/luksimg
          echo -e "\e[38;5;82m--Locking image drive\e[0m"
          cryptsetup luksClose /dev/mapper/luksimg
          losetup -d $lpd
        fi
    fi
fi

if [ "$1" == "-o" ]
  then
    if [ -z "$2" ]
      then
        echo "Please use \"sec-img -c <PATH-TO-FILE>\" to unlock an image"
      else
          losetup $lpd $2
    fi
fi

if [ "$1" == "-c" ]
  then
    if [ -z "$2" ]
      then
        echo "Please use \"sec-img -c <PATH-TO-FILE>\" to lock the image"
      else
        img_loop=$(losetup -j $2 | grep -Po '/dev/loop\d{1}')
        echo "Closing loop $img_loop"
        losetup -d $img_loop && echo "OK" || echo "Problem."
    fi
fi
