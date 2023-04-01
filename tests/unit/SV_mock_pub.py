import paho.mqtt.client as mqtt
import json
import uuid
from datetime import datetime
from random import uniform
import time

# Define constants
MQTT_BROKER = '192.168.0.8' #"192.168.0.213"  # Change this to your MQTT broker address
MQTT_PORT = 1883
VEHICLE_ID = "vehicle/12/status"  # Change this to the desired vehicle ID

N_TILES_Y = 12
N_TILES_X = 13
TILE_LENGTH_MM = 600
TILE_WIDTH_MM = 600

id = 12
x = [0.5,1.5,2.5,3.5,3.5,3.5,4.5,5.5,6.5,6.5]
y = [0.5,0.5,0.5,0.5,1.5,2.5,2.5,2.5,2.5,3.5]
yaw = [0,0,0,90,90,0,0,0,0,90]

# Define function to generate mock data
def generate_mock_data(id,x,y,yaw):
    data = {
        "type": "status_vehicle",
        "data": {
            "id": id,
            "name": "My Vehicle",
            "timestamp": datetime.now().isoformat(),
            "coordinates": {
                "x": x + uniform(-0.15,0.15),
                "y": y + uniform(-0.15,0.15),
                "yaw": yaw + uniform(-5,5),
                "x_abs": uniform(0, N_TILES_X * TILE_LENGTH_MM),
                "y_abs": uniform(0, N_TILES_Y * TILE_WIDTH_MM)
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
while True:
    for i in range(len(x)):
        print("Publishing mock data...")
        message = generate_mock_data(id,x[i],y[i],yaw[i])
        client.publish(VEHICLE_ID, message)
        print(message)
        print("Done...")
        time.sleep(1)