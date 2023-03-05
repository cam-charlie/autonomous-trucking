import os
import sys
sys.path.append(os.getcwd())
from simulation.env import Env
from simulation.realm.graph import Depot, Road, Junction
from simulation.draw.visualiser import Visualiser
from simulation.config import Config
from simulation.realm.entity import Actions

import time

def setUp() -> Env:
    print("Usage: main.py \"path-to-config-json\"")
    env = Env()
    env.reset(sys.argv[1])
    return env

def step(env: Env) -> None:
    #Temporary constants
    truck_size = 5
    safety_margin = 15

    trucks_to_release = {}
    #Work out actions
    for actor in env.realm.actors.values():
        if type(actor) is Depot:
            truck = actor.compute_actions(truck_size, safety_margin)
            if truck is not None:
                trucks_to_release[actor.id_] = truck

    truck_accelerations = {}
    for edge in env.realm.edges.values():
        if type(edge) is Road:
            truck_list = edge.trucks()
            for i in range(len(truck_list)-1,-1,-1):
                this_truck = truck_list[i]
                if i == len(truck_list)-1: #no truck in front of it: eventually going into a node
                    if type(edge.end_node) is Junction:
                        next_node = edge.end_node
                        #Work out how long before we hit the junction
                        distance = (1-this_truck.position) * edge.length
                        if this_truck.velocity > 0:
                            #Truck is moving
                            time = distance / this_truck.velocity

                            if next_node.green_in(time) == edge:
                                #Currently headed for a green light
                                if this_truck.velocity < Config.get_instance().MAX_VELOCITY and this_truck.velocity < edge.speed_limit:
                                    #Accelerate
                                    truck_accelerations[this_truck.id_] = Config.get_instance().MAX_ACCELERATION
                            else: #Currently headed for a red light
                                #Work out safe stopping distance - basically the same as below but with v = 0 as we want a complete stop
                                u = this_truck.velocity
                                v = 0.0
                                a = Config.get_instance().MAX_ACCELERATION * (-1)

                                relative_stopping_distance = ((v * v) - (u * u)) / (2 * a) + safety_margin #SUVAT

                                if distance < relative_stopping_distance:
                                    #Too close! Deccelerate
                                    truck_accelerations[this_truck.id_] = Config.get_instance().MAX_ACCELERATION * (-1)
                                elif distance > relative_stopping_distance and this_truck.velocity < Config.get_instance().MAX_VELOCITY and this_truck.velocity < edge.speed_limit:
                                    #There's space - accelerate
                                    truck_accelerations[this_truck.id_] = Config.get_instance().MAX_ACCELERATION
                        else:
                            #Truck is not moving
                            if distance > safety_margin or next_node.green_in(0) == edge:
                                #Over the safety margin or the light is green = start to move towards the junction
                                truck_accelerations[this_truck.id_] = float(Config.get_instance().MAX_ACCELERATION)

                    else:
                        if this_truck.velocity < Config.get_instance().MAX_VELOCITY and this_truck.velocity < edge.speed_limit:
                            #Accelerate
                            truck_accelerations[this_truck.id_] = float(Config.get_instance().MAX_ACCELERATION)

                else: #There is a truck in front
                    next_truck = truck_list[i+1]
                    #Generate stopping distance
                    u = this_truck.velocity
                    v = next_truck.velocity
                    a = Config.get_instance().MAX_ACCELERATION * (-1)
                    relative_stopping_distance = ((v * v) - (u * u)) / (2 * a) + safety_margin #SUVAT

                    distance = (next_truck.position - this_truck.position) * edge.length

                    if distance < relative_stopping_distance:
                        #Too close! Deccelerate
                        truck_accelerations[this_truck.id_] = float(Config.get_instance().MAX_ACCELERATION * (-1))
                        #print("Truck " + str(this_truck.id_) + ": Decelerate #5")
                    elif distance > relative_stopping_distance and this_truck.velocity < Config.get_instance().MAX_VELOCITY and this_truck.velocity < edge.speed_limit:
                        #There's space - accelerate
                        truck_accelerations[this_truck.id_] = float(Config.get_instance().MAX_ACCELERATION)
                        #print("Truck " + str(this_truck.id_) + ": Accelerate #5")
    #Actually do the step
    actions = Actions(trucks_to_release, truck_accelerations)
    env.step(actions)


if __name__ == '__main__':
    print("Usage: main.py \"path-to-config-json\"")
    env = Env()
    env.reset(sys.argv[1])
    visualiser = Visualiser(env.realm)

    while True:
        time.sleep(0.002)
        step(env)
        visualiser.refresh()
