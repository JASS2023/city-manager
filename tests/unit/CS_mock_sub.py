import paho.mqtt.client as mqtt
import time
import json
from datetime import datetime

CS_ID = "construction/12/status" 

# Define callback function for MQTT events
def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    # Subscribe to "test" topic on connect
    client.subscribe("construction/12/plan")

def on_message(client, userdata, msg):
    # Callback function for received message
    print(f"Received message: {str(msg.payload.decode())} on topic {msg.topic}")
    data = json.loads(msg.payload.decode('utf-8'))
    print(data['data'])
    #client.publish("construction/12/status")
    #time.sleep(10)
    #client.publish("construction/12/status")
    id = data['data']['id']
    x = data['data']['coordinates'][0]['x']
    y = data['data']['coordinates'][0]['y']
    quadrants = data['data']['coordinates'][0]['quadrants']

    time.sleep(1)
    print("Constructing the site...")
    message = generate_built_data(id,x,y,quadrants)
    client.publish(CS_ID, message)
    print(message)
    print("Done...")
    client.loop()
    client.loop_stop()
    #client.disconnect()
    #client.connect("192.168.0.8", 1883, 60)
    time.sleep(15)
    print("Removing the site...")
    message = generate_remove_data(id,x,y,quadrants)
    client.publish(CS_ID, message)
    print(message)
    print("Done...")
    #client.disconnect()
    #client.connect("192.168.0.8", 1883, 60)

# Create MQTT client instance
client = mqtt.Client()

# Assign callback functions to client
client.on_connect = on_connect
client.on_message = on_message

# Connect to MQTT broker
client.connect("192.168.0.223", 1883, 60)

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
            "coordinates": [{
                "x": x,
                "y": y,
                "x_abs": x,
                "y_abs": y,
                "quadrants": quadrants
            }],
        }
    }
    return json.dumps(data)

def generate_remove_data(id,x,y, quadrants):
    data = {
        "type": "status_construction_site",
        "data": {
            "message": "removed_construction_site",
            "id": id,
            "timestamp": datetime.now().isoformat(),
            "coordinates": [{
                "x": x,
                "y": y,
                "x_abs": x,
                "y_abs": y,
                "quadrants": quadrants
            }],
        }
    }
    return json.dumps(data)

# Start the MQTT client loop
client.loop_forever()

# Publish mock data every 10 seconds

