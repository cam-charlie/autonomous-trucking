from operator import ne
import os
import sys
sys.path.append(os.getcwd())
from simulation.env import Env
from simulation.realm.graph import Depot, Road
from simulation.draw.visualiser import Visualiser

if __name__ == '__main__':
    print("Usage: main.py \"path-to-config-json\"")
    env = Env()
    env.reset(sys.argv[1])
    visualiser = Visualiser(env.realm)

    #Temporary constants
    car_size = 2
    
    while True:
        actions = {}
        #Work out actions
        for actor in env.realm.actors.values():
            if type(actor) is Depot:
                for t in actor._storage:
                    truck = actor._storage[t]
                    if truck.done == False: #Truck is waiting to be released
                        next_road = env.realm.edges[truck.next_container_id()]
                        if type(next_road) is Road:
                            first_car_pos = next_road._trucks[0].position * next_road._length
                            if first_car_pos > car_size: #There is space on the road
                                #Release this truck
                                actions[actor.id] = truck.id

            elif type(actor) is Road:
                for x in range(len(actor._trucks)):
                    i = len(actor._trucks) - x - 1
                    this_truck = actor._trucks[i]
                    if x == 0: #no truck in front of it: eventually going into a node
                        if this_truck.velocity() < this_truck.config.MAX_VELOCITY:
                            #Accelerate
                            actions[actor.id] = this_truck.config.MAX_ACCELERATION
                    else:
                        next_truck = actor._trucks[i+1]
                        #Generate stopping distance
                        u = this_truck.velocity()
                        v = next_truck.velocity()
                        a = this_truck.config.MAX_ACCELERATION * (-1)
                        relative_stopping_distance = ((v * v) - (u * u)) / (2 * a) #SUVAT

                        distance = (next_truck.position - this_truck.position) * actor._length

                        if distance < relative_stopping_distance:
                            #Too close! Deccelerate
                            actions[actor.id] = this_truck.config.MAX_ACCELERATION * (-1)
                        elif distance > relative_stopping_distance and this_truck.velocity() < this_truck.config.MAX_VELOCITY:
                            #There's space - accelerate
                            actions[actor.id] = this_truck.config.MAX_ACCELERATION

        #Actually do the step        
        env.step(actions)
        visualiser.refresh()
    