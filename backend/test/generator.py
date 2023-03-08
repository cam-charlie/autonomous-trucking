#pylint: disable=protected-access, wrong-import-position
import os
import sys
import math
import random
sys.path.append(os.getcwd())
from simulation.env import Env
from simulation.lib.id import generateID
from simulation.lib.geometry.point import Point
from simulation.realm.truck import Truck
from simulation.realm.graph import Depot, Road, Node, Junction
from typing import Optional, List

env = Env()
env.reset_from_path("test/test_json/test_graph.json")

def angle(u: complex, v: complex) -> float:
    nu, nv = u/abs(u), v/abs(v)
    return abs(math.acos(nu.real*nv.real+nu.imag*nv.imag))

def add_road(start: Node,
             end: Node,
             control: Optional[Point] = None
             ) -> Road:
    length = (end.pos - start.pos).magnitude()
    if control is not None:
        # Circle from 3 points
        # Method from David Wright, Oklahoma State University
        # https://math.stackexchange.com/questions/213658/
        #   get-the-equation-of-a-circle-when-given-3-points
        z1, z2, z3 = start.pos.imag(), end.pos.imag(), control.imag()
        w = (z3-z1)/(z2-z1)
        c = (z2 - z1)*(w - abs(w)**2)/(2j*w.imag) + z1
        r = abs(z1 - c)
        # Arc length going through control
        cz1, cz2, cz3 = c-z1, c-z2, c-z3
        theta = angle(cz1,cz3) + angle(cz2,cz3)
        length = r * theta
    road = Road(id_=generateID(), start =start, end=end, length=length)
    env.realm.edges[road._id] = road
    return road

def add_junction(x: int, y: int) -> Junction:
    junction = Junction(generateID(), pos=Point(x,y))
    env.realm.nodes[junction.id_] = junction
    return junction

def add_depot(x: int, y: int, size: int = 100) -> Depot:
    depot = Depot(id_=generateID(), pos=Point(x,y), size=size)
    env.realm.nodes[depot._id] = depot
    return depot

if __name__ == "__main__":
    SCALE = 1
    d1 = add_depot(100,500)
    d2 = add_depot(500,100)
    d3 = add_depot(500,900)
    d4 = add_depot(900,500)

    depots = [d1,d2,d3,d4]

    j1 = add_junction(200,500)
    j2 = add_junction(500,200)
    j3 = add_junction(500,800)
    j4 = add_junction(800,500)

    add_road(d1,j1)
    add_road(j1,d1)
    add_road(d2,j2)
    add_road(j2,d2)
    add_road(d3,j3)
    add_road(j3,d3)
    add_road(d4,j4)
    add_road(j4,d4)

    add_road(j1,j2)
    add_road(j2,j4)
    add_road(j4,j3)
    add_road(j3,j1)

    # Trucks
    for i in range(1000):
        id_ = generateID()
        route: List[int] = []
        for j in range(random.randint(2,4)):
            choice = random.choice(depots)
            if len(route) == 0 or route[-1] != choice.id_:
                route.append(choice.id_)
        if len(route) <= 1:
            continue
        truck = Truck(id_,route[1:],random.randint(0,100))
        truck.set_current_truck_container(env.realm.nodes[route[0]])
        env.realm.trucks[id_] = truck

    with open("roundabout.json", "w", encoding='utf-8') as f:
        f.write(env.to_json())
