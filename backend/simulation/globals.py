import json

with open("../shared/example.json", 'r') as f:
    data = json.load(f)
# Set up global variables
MAX_ACCELERATION = data["globals"]["max_truck_acceleration"]
MAX_VELOCITY = data["globals"]["max_truck_velocity"]