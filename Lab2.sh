#!/bin/bash
sudo hdparm -I /dev/sda | grep Model
sudo hdparm -I /dev/sda | grep Firmware
sudo hdparm -I /dev/sda | grep -E "(Serial Number)"
df -h | grep /dev/
sudo hdparm -I /dev/sda | grep Used
sudo hdparm -I /dev/sda | grep Supported
sudo hdparm -I /dev/sda | grep PIO
sudo hdparm -I /dev/sda | grep DMA