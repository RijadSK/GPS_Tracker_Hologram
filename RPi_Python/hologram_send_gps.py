# Rijad Skrobo
# 14.01.2024.

from time import sleep
import sys
sys.path.insert(0, 'gps_hat')

from gps_hat import gps_lib

from Hologram.HologramCloud import HologramCloud

hologram = HologramCloud(dict(), network='cellular')

try:
    x = None
    y = None
    z = None
    position = list()

    result = hologram.network.disconnect()

    while 1:
        if x is None:
            x = gps_lib.RMC_Read() #Recommended minimum specific GNSS data
        if x is not None:
            a = list(x)
            position = a
            print("Latitude = ",a[0] + "    Longitude = ",a[1])
            print("UTC Time = ",a[2])
            print("Date = ",a[4])
            print("speed over ground = ",a[3])
            print("\n")

        if y is None:
            y = gps_lib.GSV_Read() # GNSS satellites in view
        if y is not None:
            a = list(y)
            print("Total Number of Satellites = ",a[0])
            print("Satellite ID number = ",a[1])
            print("Elevation = ",a[2])
            print("SNR = ",a[3])
            print("\n")

        if z is None:
            z = gps_lib.GGA_Read() #Global positioning system (GPS) fix data
        if z is not None:
            a = list(z)
            print(a)
            print("Latitude = ",a[0] + "    Longitude = ",a[1])
            print("UTC Time = ",a[2])
            print("Satellite Positioning = ",a[3])
            print("GPS Quality indicator = ",a[4])
            print("\n")


        if result == False:
            print("Failed to connect to cell network")

        if x is not None and y is not None and z is not None:
            break

    if result == False:
        print("Failed to connect to cell network")

    location_message = "&field1=" + position[0] + "&field2=" + position[1]
    print(location_message)
    response_code = hologram.sendMessage(location_message, timeout = 30)
    print(hologram.getResultString(response_code)) # Prints 'Message sent successfully'.

    hologram.network.disconnect()
    sleep(10)


except KeyboardInterrupt:
    hologram.network.disconnect()
    sys.exit(0)
