import paho.mqtt.client as mqtt
import json
import uuid
from datetime import datetime, timedelta
from random import uniform
import time

# Define constants
MQTT_BROKER = '192.168.0.8' #"192.168.0.213"  # Change this to your MQTT broker address
MQTT_PORT = 1883
TL1_ID = "traffic-light/1/1"  # Change this to the desired traffic light ID
TL2_ID = "traffic-light/1/2"

id = 12
label = "Duckiebot"
duckieId = 1
caseString = "close" 

color = ["red", "green"]

# Define function to generate mock data
def generate_first_mock(color):
    data = {
        "type": "status_traffic-light",
        "data": {
            "color": color
        }
    }
    return json.dumps(data)

def generate_second_mock(color):
    data = {
        "type": "status_traffic-light",
        "data": {
            "color": color
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

# Publish mock data

print("Switching both traffic lights...")

for i in range(len(color)):
    message1 = generate_first_mock(color[i])
    message2 = generate_second_mock(color[i-1])
    client.publish(TL1_ID, message1)
    print(message1)
    client.publish(TL2_ID, message2)
    print(message2)    
    print("Done...")
    time.sleep(5)