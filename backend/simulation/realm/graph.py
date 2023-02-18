from __future__ import annotations
from abc import ABC
from simulation.lib.geometry import Point
from collections import deque
import math
from simulation.realm.truck import Collision

from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from simulation.realm.truck import Truck
    from simulation.lib.geometry import Point
    from typing import List, Dict, Optional, Any

class TruckContainer(ABC):

    def __init__(self, id: int) -> None:
        self._id: int = id
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

    def __init__(self, id: int, start: Node, end: Node) -> None:
        super().__init__(id)
        start.addOutgoing(self)
        end.addIncoming(self)

class Node(TruckContainer, ABC):

    def __init__(self, id: int, pos: Point) -> None:
        super().__init__(id)
        self._pos = pos
        self._incoming: List[Edge] = []
        self._outgoing: List[Edge] = []

    @property
    def pos(self) -> Point:
        return self._pos

    def addIncoming(self, e: Edge) -> None:
        self._incoming.append(e)

    def addOutgoing(self, e: Edge) -> None:
        self._outgoing.append(e)

    @staticmethod
    def from_json(json: Any) -> Node:
        if json["type"] == "junction":
            return Junction.from_json(json)
        else:
            raise NotImplementedError

class Junction(Node):
    def __init__(self, id: int, pos: Point) -> None:
        super().__init__(id, pos)
        self._routing_table: Dict[int, int] = {} # Mapping from destination id to outgoing index

    def entry(self, truck: Truck) -> None:
        self._outgoing[self._routing_table[truck.destination]].entry(truck)

    @staticmethod
    def from_json(json: Any) -> Junction:
        return Junction(json["node_id"], Point.from_json(json["position"]))

class Source(Node):
    pass

class Sink(Node):
    pass

class Road(Edge):
    """One way road.
    """

    def __init__(self, id: int, start: Node, end: Node, length: float) -> None:
        """Initializes a road object

        Args:
            start:
            end:
        """
        super().__init__(id, start, end)

        self._length = length
        self._start = start
        self._end = end

    def getPosition(self, u: float) -> Point:
        """ Obtains interpolated position

        Args:
            u: interpolation parameter

        Return:
            Point u along road
        """
        return Point(
            u * (self._end.pos().x() - self._start.pos().x()),
            u * (self._end.pos().y() - self._start.pos().y())
            )

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
