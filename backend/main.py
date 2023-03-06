import os
import sys
sys.path.append(os.getcwd())
from simulation.env import Env
from simulation.realm.graph import Depot, Road, Junction
from simulation.draw.visualiser import Visualiser
from simulation.config import Config
from simulation.realm.entity import Actions
from typing import Dict

import time

def setUp() -> Env:
    print("Usage: main.py \"path-to-config-json\"")
    env = Env()
    env.reset(sys.argv[1])
    return env

def step(env: Env) -> None:
    #Temporary constants
    truck_size = 5
    safety_margin = 20

    trucks_to_release = {}
    #Work out actions
    for actor in env.realm.actors.values():
        if type(actor) is Depot:
            truck = actor.compute_actions(truck_size, safety_margin)
            if truck is not None:
                trucks_to_release[actor.id_] = truck

    truck_accelerations: Dict[int, float] = {}
    for edge in env.realm.edges.values():
        if type(edge) is Road:
            edge.compute_actions(safety_margin, truck_accelerations)
    #Actually do the step
    actions = Actions(trucks_to_release, truck_accelerations)
    #print(actions)
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
