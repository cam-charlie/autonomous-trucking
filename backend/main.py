import os
import sys
sys.path.append(os.getcwd())
from simulation.env import Env
from simulation.realm.graph import Depot, Road
from simulation.draw.visualiser import Visualiser
from simulation.config import Config

def setUp() -> Env:
    env = Env()
    return env


def step(env: Env) -> None:
    #Temporary constants
    truck_size = 2
    safety_margin = 5

    actions = {}
    #Work out actions
    for actor in env.realm.actors.values():
        if type(actor) is Depot:
            act = actor.compute_actions(truck_size, safety_margin)
            if act is not None:
                actions[actor.id_] = act

    for edge in env.realm.edges.values():
        if type(edge) is Road:
            for i in range(len(edge._trucks)-1,-1,-1):
                this_truck = edge._trucks[i]
                if i == len(edge._trucks)-1: #no truck in front of it: eventually going into a node
                    if this_truck.velocity < Config.get_instance().MAX_VELOCITY:
                        #Accelerate
                        actions[this_truck.id_] = float(Config.get_instance().MAX_ACCELERATION)
                else:
                    next_truck = edge._trucks[i+1]
                    #Generate stopping distance
                    u = this_truck.velocity
                    v = next_truck.velocity
                    a = Config.get_instance().MAX_ACCELERATION * (-1)
                    relative_stopping_distance = ((v * v) - (u * u)) / (2 * a) + safety_margin #SUVAT

                    distance = (next_truck.position - this_truck.position) * edge._length

                    if distance < relative_stopping_distance:
                        #Too close! Deccelerate
                        actions[this_truck.id_] = float(Config.get_instance().MAX_ACCELERATION * (-1))
                    elif distance > relative_stopping_distance and this_truck.velocity < Config.get_instance().MAX_VELOCITY:
                        #There's space - accelerate
                        actions[this_truck.id_] = float(Config.get_instance().MAX_ACCELERATION)

    #Actually do the step
    env.step(actions)


if __name__ == '__main__':
    print("Usage: main.py \"path-to-config-json\"")
    env = Env()
    env.reset(sys.argv[1])
    visualiser = Visualiser(env.realm)

    #Temporary constants
    truck_size = 2
    safety_margin = 5

    while True:
        actions = {}
        #Work out actions
        for actor in env.realm.actors.values():
            if type(actor) is Depot:
                act = actor.compute_actions(truck_size, safety_margin)
                if act is not None:
                    actions[actor.id_] = act

        for edge in env.realm.edges.values():
            if type(edge) is Road:
                for i in range(len(edge._trucks)-1,-1,-1):
                    this_truck = edge._trucks[i]
                    if i == len(edge._trucks)-1: #no truck in front of it: eventually going into a node
                        if this_truck.velocity < Config.get_instance().MAX_VELOCITY:
                            #Accelerate
                            actions[this_truck.id_] = float(Config.get_instance().MAX_ACCELERATION)
                    else:
                        next_truck = edge._trucks[i+1]
                        #Generate stopping distance
                        u = this_truck.velocity
                        v = next_truck.velocity
                        a = Config.get_instance().MAX_ACCELERATION * (-1)
                        relative_stopping_distance = ((v * v) - (u * u)) / (2 * a) + safety_margin #SUVAT

                        distance = (next_truck.position - this_truck.position) * edge._length

                        if distance < relative_stopping_distance:
                            #Too close! Deccelerate
                            actions[this_truck.id_] = float(Config.get_instance().MAX_ACCELERATION * (-1))
                        elif distance > relative_stopping_distance and this_truck.velocity < Config.get_instance().MAX_VELOCITY:
                            #There's space - accelerate
                            actions[this_truck.id_] = float(Config.get_instance().MAX_ACCELERATION)

        #Actually do the step
        env.step(actions)
        visualiser.refresh()

