# Things used in this project

    Raspberry Pi Zero, 3, 2 Model B or newer

    SD card with Linux-based operating system for Raspberry Pi

    Hologram Nova USB Modem  

    GPS Hat for Raspberry Pi from SB Components

    2.4A USB power supply (anything less will not power the modem), or in my case power bank

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

# Configuring Hologram Data Route

I have used Hologram IoT Dashboard. There I have configured data routes, for routing data received by Hologram network to Firebase Realtime Database.  
Example of my configuration is shown here:


![hologram_data_route](https://github.com/RijadSK/GPS_Tracker_Hologram/assets/68814453/97a1c0be-fb44-4d79-94eb-06745f4ce76b)

![hologram_data_route_hook](https://github.com/RijadSK/GPS_Tracker_Hologram/assets/68814453/172fecaf-3f3b-4a71-953b-05dfb89f9547)

Destination URL was     https://gpstracker-84fdb-default-rtdb.europe-west1.firebasedatabase.app/datatoadd.json?auth=*******   
Payload for data was    {"DeviceID":"<<device_id>>","Timestamp":"<<timestamp>>","AddedData":"<<decdata>>"} 

# Firebase application

It was necessary to create Firebase applications for mobile phone and Realtime Database for storing GPS positions of car.  

![gpstracker_firebase](https://github.com/RijadSK/GPS_Tracker_Hologram/assets/68814453/69b209aa-39eb-4474-b68f-ad37d36e5e49)

Data routed to realtime database would look like this:   
![realtime_database_data](https://github.com/RijadSK/GPS_Tracker_Hologram/assets/68814453/71013e49-9431-4d7b-84b0-faa694dd223c)

