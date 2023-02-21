# Shared between both frontend and backend

# Intermediate Data Format
Point:
    {
        "x": float,
        "y": float
    }

Truck:
    {
        "id": int,
        "destination_id": int,
        "route": List[int] // list of node ids
    }

Road:
    {
        "id": int,
        "start_node_id": int,
        "end_node_id": int,
        "length": float,
    }

Node:
    {
        "type": // should be one of ["junction", "depot"]
        "id": int,
        "position: Point
    }

// position required by front-end only
// id must be unique across all trucks/roads/nodes

Globals:
    {
        "max_truck_acceleration": float,
        "max_truck_velocity": float
    }