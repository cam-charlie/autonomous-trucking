from __future__ import annotations
from abc import ABC
from simulation.draw.utils import Drawable, DEFAULT_FONT
import pygame
from collections import deque
from ..lib.geometry import Point
from ..config import InvalidConfiguration
from .truck import Collision
from .entity import Actor, Entity
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from .truck import Truck
    from typing import List, Dict, Any, Optional

class TruckContainer(Entity, Drawable, ABC):

    def __init__(self, id: int) -> None:
        super().__init__(id)
        self._trucks: deque[Truck] = deque()

    def update(self, dt: float) -> None:
        pass

    def entry(self, truck: Truck) -> None:
        """ A new truck has generated / entered this data structure

        Args:
            truck: the new truck.
                Invariant: truck position is normalized
        """
        self._trucks.append(truck)
        truck.set_current_truck_container(self)

        if truck.destination == self.id:
            truck.reached_next_destination()
        if truck.done():
            truck._accumulated_reward += 1

    @property
    def id(self) -> int:
        return self._id

class Edge(TruckContainer, ABC):

    def __init__(self, id: int, start: Node, end: Node) -> None:
        super().__init__(id)
        start.addOutgoing(self)
        end.addIncoming(self)
        self._start: Node = start
        self._end: Node = end
        self._cost: float = 1

    @property
    def cost(self) -> float:
        return self._cost

class Node(TruckContainer, ABC):

    def __init__(self, id: int, pos: Point) -> None:
        super().__init__(id)
        self._pos = pos
        self._incoming: List[Edge] = []
        self._outgoing: List[Edge] = []
        self._routing_table: Dict[int, int] = {} # Mapping from destination id to outgoing index

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
        elif json["type"] == "depot":
            return Depot.from_json(json)
        else:
            raise NotImplementedError

class Junction(Node):

    def entry(self, truck: Truck) -> None:
        super().entry(truck)
        if truck.done():
            raise InvalidConfiguration()
        self._trucks.pop()
        self._outgoing[self._routing_table[truck.destination]].entry(truck)

    @staticmethod
    def from_json(json: Any) -> Junction:
        return Junction(json["id"], Point.from_json(json["position"]))

    def draw(self, screen: pygame.Surface) -> None:

        pygame.draw.circle(screen, "blue", self.pos.to_tuple(), 10)

        text_surface = DEFAULT_FONT.render('J', False, (255, 255, 255))
        text_rect = text_surface.get_rect(center=self.pos.to_tuple())
        screen.blit(text_surface, text_rect)

        for _ in self._trucks:
            pygame.draw.circle(screen, "green", self.pos.to_tuple(), 2)

class Depot(Node, Actor):

    def __init__(self, id: int, pos: Point, size: int = 10) -> None:
        super().__init__(id, pos)
        self._storage: Dict[int,Truck] = {}
        self._storage_size = size

    def entry(self, truck: Truck) -> None:
        super().entry(truck)
        if truck.done():
            return
        self._storage[truck.id] = truck
        # TODO(mark) no space
        if len(self._storage) > self._storage_size:
            pass

    def act(self, action: Optional[float], dt: float) -> None:
        """ Release the truck with id: action
        """
        if action is None:
            return
        tid = int(action)
        if tid in self._storage:
            truck = self._storage.pop(tid)
            self._outgoing[self._routing_table[truck.destination]].entry(truck)

    def update(self, dt: float) -> None:
        for truck in self._storage.values():
            truck._velocity = 0

    @staticmethod
    def from_json(json: Any) -> Depot:
        return Depot(json["id"], Point.from_json(json["position"]))

    def draw(self, screen: pygame.Surface) -> None:

        pygame.draw.circle(screen, "blue", self.pos.to_tuple(), 10)

        text_surface = DEFAULT_FONT.render('D', False, (255, 255, 255))
        text_rect = text_surface.get_rect(center=self.pos.to_tuple())
        screen.blit(text_surface, text_rect)

        for _ in self._trucks:
            pygame.draw.circle(screen, "green", self.pos.to_tuple(), 2)

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
        self._cost = length

    def getPosition(self, u: float) -> Point:
        """ Obtains interpolated position

        Args:
            u: interpolation parameter

        Return:
            Point u along road
        """
        return self._start.pos + Point(
            u * (self._end.pos.x - self._start.pos.x),
            u * (self._end.pos.y - self._start.pos.y)
            )

    def entry(self, truck: Truck) -> None:
        super().entry(truck)
        if truck.done():
            return
        truck.position = truck.position / self._length

    def update(self, dt: float) -> None:
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

    def draw(self, screen: pygame.Surface) -> None:
        pygame.draw.line(screen, "black", self._start.pos.to_tuple(), self._end.pos.to_tuple(), width=5)
        for truck in self._trucks:
            pygame.draw.circle(screen, "green", self.getPosition(truck.position).to_tuple(), 5)