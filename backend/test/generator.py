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
env.reset("test/test_json/test_graph.json")

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
    churchill = add_depot(125*SCALE, 75*SCALE, 200) # Churchill
    # me = add_depot(350*SCALE, 30*SCALE, 50) # Murray Edwards
    # jesus = add_depot(740*SCALE, 230*SCALE, 180) # Jesus
    # johns = add_depot(585*SCALE, 300*SCALE, 500) # St Johns
    robinson = add_depot(210*SCALE, 400*SCALE, 100) # Robinson
    wolfson = add_depot(155*SCALE, 700*SCALE, 60) # Wolfson
    darwin = add_depot(480*SCALE, 600*SCALE, 70) # Darwin
    # christ = add_depot(710*SCALE, 360*SCALE, 300) # Christ
    corpus = add_depot(590*SCALE, 500*SCALE, 20) # Corpus
    aru = add_depot(970*SCALE, 455*SCALE, 100) # ARU
    queens = add_depot(510*SCALE, 555*SCALE, 200) # Queens
    # downing = add_depot(760*SCALE, 575*SCALE, 150) # Downing
    # kings = add_depot(555*SCALE, 420*SCALE, 400) # Kings

    depots: List[Depot] = [
        churchill,
        robinson,
        wolfson,
        darwin,
        corpus,
        aru,
        queens
    ]

    j0 = add_junction(121*SCALE, 121*SCALE)
    j1 = add_junction(430*SCALE, 200*SCALE)
    j2 = add_junction(450*SCALE, 690*SCALE)
    j3 = add_junction(282*SCALE, 377*SCALE)
    j4 = add_junction(300*SCALE, 155*SCALE)
    j5 = add_junction(470*SCALE, 600*SCALE)
    j6 = add_junction(515*SCALE, 172*SCALE)
    j7 = add_junction(830*SCALE, 650*SCALE)
    j8 = add_junction(580*SCALE, 620*SCALE)
    j9 = add_junction(480*SCALE, 575*SCALE)
    j10 = add_junction(735*SCALE, 475*SCALE)

    add_road(churchill,j0)
    add_road(j0,churchill)
    add_road(j3, robinson)
    add_road(robinson, j3)
    add_road(j3,j4)
    add_road(j4,j3)
    add_road(j0,j4)
    add_road(j4,j0)
    add_road(j4,j1)
    add_road(j1,j4)
    add_road(j1,j5)
    add_road(j5,j2)
    add_road(j6,j1)
    add_road(j2,j7)
    add_road(j7,aru)
    add_road(aru,j7)
    add_road(wolfson,j2)
    add_road(j2,wolfson)
    add_road(j5,j9)
    add_road(j9,j5)
    add_road(j9,j8)
    add_road(j8,j9)
    add_road(j9,darwin)
    add_road(darwin,j9)
    add_road(j9,queens)
    add_road(queens,j9)
    add_road(j8,corpus)
    add_road(corpus,j8)
    add_road(j8,j10)
    add_road(j10,j8)
    add_road(j7,j10)
    add_road(j10,j6)

    # Trucks
    for i in range(100):
        id_ = generateID()
        route: List[int] = []
        for j in range(random.randint(3,10)):
            choice = random.choice(depots)
            if len(route) == 0 or route[-1] != choice.id_:
                route.append(choice.id_)
        truck = Truck(id_,route[1:],random.randint(0,100))
        truck.set_current_truck_container(env.realm.nodes[route[0]])
        env.realm.trucks[id_] = truck

    with open("generated.json", "w", encoding='utf-8') as f:
        f.write(env.to_json())
