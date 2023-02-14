from __future__ import annotations
from abc import ABC
from simulation.lib.geometry import Point
from collections import deque
import math
from simulation.realm.truck import Collision
from simulation.lib.id import generateID

from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from simulation.realm.truck import Truck
    from simulation.lib.geometry import Point
    from typing import List, Dict

class TruckContainer(ABC):

    def __init__(self) -> None:
        self._id: int = generateID()
        self._trucks: deque[Truck] = deque()

    def step(self, dt: float) -> None:
        pass

    def entry(self, truck: Truck) -> None:
        """ A new truck has generated / entered this data structure

        Args:
            truck: the new truck. 
                Invariant: truck position is normalized
        """
        self._trucks.append(truck)

    @property
    def id(self) -> int:
        return self._id

class Edge(TruckContainer, ABC):

    def __init__(self, start: Node, end: Node) -> None:
        super().__init__()
        start.addOutgoing(self)
        end.addIncoming(self)

class Node(TruckContainer, ABC):

    def __init__(self, pos: Point) -> None:
        super().__init__()
        self._pos = pos
        self._incoming: List[Edge] = []
        self._outgoing: List[Edge] = []

    @property
    def pos(self):
        return self._pos

    def addIncoming(self, e: Edge) -> None:
        self._incoming.append(e)

    def addOutgoing(self, e: Edge) -> None:
        self._outgoing.append(e)

class Junction(Node):
    def __init__(self, pos: Point) -> None:
        super().__init__(pos)
        self._routing_table: Dict[int, int] = {} # Mapping from destination id to outgoing index

    def entry(self, truck: Truck) -> None:
        self._outgoing[self._routing_table[truck.destination]].entry(truck)

class Source(Node):
    pass

class Sink(Node):
    pass

class Road(Edge):
    """One way road.

    Represented as a spline curve
    """

    def __init__(self, start: Node, end: Node, vin: Point = None, vout: Point = None) -> None:
        """Initializes a road object

        Args:
            start:
            end:
            vin: vector describing incoming direction
            vout: vector describing outgoing direction
        """
        super().__init__(start, end)

        self._length = (end.pos-start.pos).magnitude()
        self._start = start
        self._end = end

        # position = au^3 + bu^2 + cu + d
        if vin is None:
            vin = end.pos - start.pos
        if vout is None:
            vout = end.pos - start.pos

        dudx = math.inf
        if (end.pos.x-start.pos.x) > 0:
            dudx = 1.0 / (end.pos.x-start.pos.x)
        dudy = math.inf
        if (end.pos.y-start.pos.y) > 0:
            dudy = 1.0 / (end.pos.y-start.pos.y)

        dp0 = Point(vin.x*dudx, vin.y * dudy)
        dp1 = Point(vout.x*dudx, vout.y * dudy)
        self._dx = start.pos.x
        self._dy = start.pos.y
        self._cx = dp0.x
        self._cy = dp0.y
        self._ax = dp1.x+self._cx+2*(self._dx-end.pos.x)
        self._ay = dp1.y+self._cy+2*(self._dy-end.pos.y)
        self._bx = end.pos.x-self._ax-self._cx-self._dx
        self._by = end.pos.y-self._ay-self._cy-self._dy

    def getPosition(self, u: float) -> Point:
        """ Obtains interpolated position

        Args:
            u: interpolation parameter

        Return:
            Point u along road
        """
        return Point(
            u*u*u*self._ax+u*u*self._bx+u*self._cx+self._dx,
            u*u*u*self._ay+u*u*self._by+u*self._cy+self._dy)

    def entry(self, truck: Truck) -> None:
        super().entry(truck)
        truck.position = truck.position / self._length

    def step(self, dt: float) -> None:
        for truck in self._trucks:
            if not truck.stepped:
                truck.position += truck.velocity * dt / self._length
                truck.stepped = True
        for i, truck in enumerate(self._trucks):
            if i+1 < len(self._trucks) and self._trucks[i+1].position > truck.position:
                raise Collision
        while len(self._trucks) > 0:
            if self._trucks[0].position > 1:
                truck = self._trucks.pop()
                truck.position = (truck.position-1) * self._length
                self._end.entry(truck)
            else:
                break
