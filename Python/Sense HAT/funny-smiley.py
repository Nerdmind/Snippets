#!/usr/bin/python

from sense_hat import SenseHat
from time import sleep
from random import choice
import threading

#===============================================================================
# Define the default rotation of the pixel matrix
#===============================================================================
rotation = 90

#===============================================================================
# Define the RGB color codes for the pixel matrix
#===============================================================================
a = [0, 0, 50]
b = [75, 25, 0]
c = [0, 50, 25]
n = [0,0,0]
r = [50, 0, 0]

#===============================================================================
# LED pixel matrix for first image
#===============================================================================
image_a = [
	a,a,a,a,a,a,a,a,
	a,c,a,a,a,a,c,a,
	a,a,c,a,a,c,a,a,
	a,a,a,a,a,a,a,a,
	a,c,c,c,c,c,c,a,
	a,a,c,c,c,c,a,a,
	a,a,a,a,a,a,a,a,
	a,a,a,a,a,a,a,a
]

#===============================================================================
# LED pixel matrix for second image
#===============================================================================
image_b = [
	a,a,a,a,a,a,a,a,
	a,r,r,a,a,r,r,a,
	a,r,r,a,a,r,r,a,
	a,a,a,a,a,a,a,a,
	a,c,c,c,c,c,c,a,
	a,c,n,n,n,n,c,a,
	a,a,c,c,c,c,a,a,
	a,a,a,a,a,a,a,a
]

#===============================================================================
# Update rotation when the device is moved in a certain direction
#===============================================================================
def updateDisplayRotation(SenseHat, default=0):
	last_rotation = default

	while True:
		x = round(SenseHat.get_accelerometer_raw()['x'], 0)
		y = round(SenseHat.get_accelerometer_raw()['y'], 0)

		if x == -1:
			if last_rotation != 90:
				last_rotation = 90
				SenseHat.set_rotation(90)
		elif x == 1:
			if last_rotation != 270:
				last_rotation = 270
				SenseHat.set_rotation(270)
		elif y == -1:
			if last_rotation != 180:
				last_rotation = 180
				SenseHat.set_rotation(180)
		elif y == 1:
			if last_rotation != 0:
				last_rotation = 0
				SenseHat.set_rotation(0)
		else:
			if last_rotation != default:
				last_rotation = default
				SenseHat.set_rotation(default)

		sleep(0.5)

SenseHat = SenseHat()
SenseHat.set_rotation(rotation)

#===============================================================================
# Run updateDisplayRotation() in the background
#===============================================================================
BackgroundThread = threading.Thread(target=updateDisplayRotation, args=(SenseHat, rotation))
BackgroundThread.daemon = True
BackgroundThread.start()

#===============================================================================
# Change the smileys face after a random period of time
#===============================================================================
while True:
	SenseHat.set_pixels(image_a)
	sleep(choice([2,4,6,8]))

	SenseHat.set_pixels(image_b)
	sleep(choice([1.0, 1.5, 2.0]))