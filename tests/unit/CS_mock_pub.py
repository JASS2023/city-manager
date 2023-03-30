import paho.mqtt.client as mqtt
import json
import uuid
from datetime import datetime, timedelta
from random import uniform
import time

# Define constants
MQTT_BROKER = '192.168.0.8' #"192.168.0.213"  # Change this to your MQTT broker address
MQTT_PORT = 1883
CS_ID = "construction/12/plan"  # Change this to the desired construction ID

N_TILES_Y = 12
N_TILES_X = 13
TILE_LENGTH_MM = 600
TILE_WIDTH_MM = 600

id = 12
x = 9
y = 9
quadrants = [1,4]
speed = 50

# Define function to generate mock data
def generate_plan_data(id,x,y,quadrants,speed):
    data = {
        "type": "status_construction_site",
        "data": {
            "id": id,
            "coordinates": [{
                "x": x,
                "y": y,
                "x_abs": x,
                "y_abs": y,
                "quadrants": quadrants
            }],
            "startDateTime": datetime.now().isoformat(),
            "endDateTime": (datetime.now() + timedelta(seconds=10)).isoformat(),
            "maximumSpeed": speed
        }
    }
    return json.dumps(data)

# Define callback function to handle MQTT connection
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))

# Define MQTT client and connect to broker
client = mqtt.Client()
client.on_connect = on_connect
client.connect(MQTT_BROKER, MQTT_PORT)

# Publish mock data every 10 seconds

print("Planning the site...")
message = generate_plan_data(id,x,y,quadrants,speed)
client.publish(CS_ID, message)
print(message)
print("Done...")