import paho.mqtt.client as mqtt
import json
import uuid
from datetime import datetime
from random import uniform
import time

# Define constants
MQTT_BROKER = '192.168.0.8' #"192.168.0.213"  # Change this to your MQTT broker address
MQTT_PORT = 1883
CS_ID = "construction/12/status"  # Change this to the desired vehicle ID

N_TILES_Y = 12
N_TILES_X = 13
TILE_LENGTH_MM = 600
TILE_WIDTH_MM = 600

id = 12
x = 8
y = 8
quadrants = [1,4]

# Define function to generate mock data
def generate_built_data(id,x,y, quadrants):
    data = {
        "type": "status_construction_site",
        "data": {
            "message": "built_construction_site",
            "id": id,
            "timestamp": datetime.now().isoformat(),
            "coordinates": {
                "x": x,
                "y": y,
                "x_abs": x,
                "y_abs": y,
                "quadrants": quadrants
            },
        }
    }
    return json.dumps(data)

def generate_remove_data(id,x,y, quadrants):
    data = {
        "type": "status_construction_site",
        "data": {
            "message": "remove_construction_site",
            "id": id,
            "timestamp": datetime.now().isoformat(),
            "coordinates": {
                "x": x,
                "y": y,
                "x_abs": x,
                "y_abs": y,
                "quadrants": quadrants
            },
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

# Publish mock data every .5 seconds

print("Constructing the site...")
message = generate_built_data(id,x,y,quadrants)
client.publish(CS_ID, message)
print(message)
print("Done...")
time.sleep(10)
print("Removing the site...")
message = generate_remove_data(id,x,y,quadrants)
client.publish(CS_ID, message)
print(message)
print("Done...")