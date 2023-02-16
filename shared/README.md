# Shared Files Will Live Here


# Intermediate Data Format
Point:
    {
        "x": ...,
        "y": ...
    }

Truck:
    {
        "truck_id": ...,
        "destination_id": ...,
    }

^ I should consider routes at some point

Road:
    {
        "road_id": ...,
        "start_node_id": //id of the node it points to
        "end_node_id": ...
        "length": ...,
    }

Node:
    {
        "type": // should be one of ["junction", "source", "sink"]
        "node_id": ...,
        "position: Point
    }

// position required by front-end only

Globals:
    {
        "max_truck_acceleration": ...,
        "max_truck_velocity": ...,
    }