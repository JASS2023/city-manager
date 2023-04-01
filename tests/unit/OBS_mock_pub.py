import paho.mqtt.client as mqtt
import json
import uuid
from datetime import datetime, timedelta
from random import uniform
import time

# Define constants
MQTT_BROKER = '192.168.0.8' #"192.168.0.213"  # Change this to your MQTT broker address
MQTT_PORT = 1883
OBS_ID = "obstacle/12/status"  # Change this to the desired obstacle ID

message = "discover_obstacle"
id = 12
label = "Duckiebot"
duckieId = 1
caseString = "close" 

# Define function to generate mock data
def generate_mock_data(id,label,duckieId,caseString):
    data = {
        "type": "status_obstacle",
        "data": {
            "message": message,
            "id": id,
            "timestamp": datetime.now().isoformat(),
            "label": label,
            "duckieId": duckieId,
            "case": caseString
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

print("Placing obstacle...")
message = generate_mock_data(id,label,duckieId,caseString)
client.publish(OBS_ID, message)
print(message)
print("Done...")