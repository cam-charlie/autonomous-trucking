# Shared Files Will Live Here


# Intermediate Data Format
Point:
    {
        "x": float,
        "y": float
    }

Truck:
    {
        "truck_id": int,
        "destination_id": int,
        "route": List[int] // list of node_ids
    }

Road:
    {
        "road_id": int,
        "start_node_id": int, //id of the node it points to
        "end_node_id": int,
        "length": float,
    }

Node:
    {
        "type": // should be one of ["junction", "source", "sink"]
        "node_id": int,
        "position: Point
    }

// position required by front-end only
// road_ids and node_ids must be different and unique!

Globals:
    {
        "max_truck_acceleration": float,
        "max_truck_velocity": float
    }