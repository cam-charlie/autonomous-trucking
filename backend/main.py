import os
import sys
sys.path.append(os.getcwd())
from simulation.env import Env
from simulation.draw.visualiser import Visualiser

if __name__ == '__main__':
    print("Usage: main.py \"path-to-config-json\"")
    env = Env()
    env.reset(sys.argv[1])
    visualiser = Visualiser(env.realm)

    while True:
        env.step({})
        visualiser.refresh()
        