# Things used in this project

    Raspberry Pi Zero, 3, 2 Model B or newer

    SD card with Linux-based operating system for Raspberry Pi

    Hologram Nova USB Modem

    2.4A USB power supply (anything less will not power the modem)

    Hologram account

    Hologram SIM card

    Make sure the SIM is activated

# Installing Hologram SDK

I was using Python 3.9.2 version. Hologram SDK was not maintained for newer version of Python3, which I had as installed earlier.

Steps to install Hologram SDK were:  
**sudo apt-get update**  
**curl -L hologram.io/python-install | bash**  

After a successful install plug in the NOVA USB modem and wait for one solid light and one blinking light.
Once we have lights, run:  
**sudo hologram version**

Just to test that everything is working well, try these things to get estimated location and send message to the cloud:  
**sudo hologram modem location**  
**sudo hologram send "Hello World"**  

More detailed explanation can be seen at:  
https://www.hackster.io/hologram/add-cellular-to-a-raspberry-pi-with-hologram-nova-ea5926



