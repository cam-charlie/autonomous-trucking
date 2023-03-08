from typing import List
import numpy as np
import yaml
import random

depots: List[int] = [1000078, 1000081, 1000084, 1000087, 1000090, 1000093, 1000096, 1000099, 1000102, 1000105, 1000108, 1000111, 1000114, 1000117, 1000120]
minimum_id: int = 10000
groups: int = 10
N: int = 50
maximum_route_length = 5
maximum_start_time = 60

truck2group = np.random.randint(0, groups,size=(N))
group2route = [np.random.choice(depots, size=(maximum_route_length),replace=False) for _ in range(groups)]
group2route_max = np.random.randint(2,maximum_route_length+1,size=(groups))
group2start = np.random.randint(0,maximum_start_time,size=(groups))

def generate_truck_yaml(i):
    group = truck2group[i]
    route = group2route[group][:group2route_max[group]]
    result = {
        "node": int(route[0]),
        "fraction": 0.0,
        "velocity": 0.0,
        "start time": int(group2start[group]),
        "route": route[1:].tolist()
    }
    return result
 
output = {}
vehicles = {}
for i in range(20):
    vehicles[i] = generate_truck_yaml(5)

print(yaml.dump({'vehicles':
        {i: generate_truck_yaml(i-minimum_id) for i in range(minimum_id,minimum_id+N)}
    },default_flow_style=False))