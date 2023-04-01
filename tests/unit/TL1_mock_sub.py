import paho.mqtt.client as mqtt

# Define callback function for MQTT events
def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    # Subscribe to "test" topic on connect
    client.subscribe("traffic-light/1/1")

def on_message(client, userdata, msg):
    # Callback function for received message
    print(f"Received message: {str(msg.payload.decode())} on topic {msg.topic}")

# Create MQTT client instance
client = mqtt.Client()

# Assign callback functions to client
client.on_connect = on_connect
client.on_message = on_message

# Connect to MQTT broker
client.connect("192.168.0.8", 1883, 60)

# Start the MQTT client loop
client.loop_forever()