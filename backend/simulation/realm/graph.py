from __future__ import annotations
from abc import ABC
from simulation.draw.utils import Drawable, DEFAULT_FONT
import pygame
from collections import deque
from ..lib.geometry import Point
from ..config import InvalidConfiguration, Config
from .entity import Actor, Entity
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from .truck import Truck
    from typing import List, Dict, Any, Optional, Deque

class TruckContainer(Entity, Drawable, ABC):

    def __init__(self, id_: int) -> None:
        super().__init__(id_)
        self._trucks: deque[Truck] = deque()

    def get(self, i: int) -> Truck:
        return self._trucks[i]

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

        if truck.destination == self.id_:
            truck.reached_next_destination()
        if truck.done():
            truck._accumulated_reward += 1

    @property
    def id_(self) -> int:
        return self._id

    @property
    def trucks(self) -> Deque[Truck]:
        return self._trucks

class Edge(TruckContainer, ABC):

    def __init__(self, id_: int, start: Node, end: Node) -> None:
        super().__init__(id_)
        start.add_outgoing(self)
        end.add_incoming(self)
        self._start: Node = start
        self._end: Node = end
        self._cost: float = 1

    @property
    def cost(self) -> float:
        return self._cost

    @property
    def start(self) -> Node:
        return self._start

    @property
    def end(self) -> Node:
        return self._end

class Node(TruckContainer, ABC):

    def __init__(self, id_: int, pos: Point) -> None:
        super().__init__(id_)
        self._pos = pos
        self._incoming: List[Edge] = []
        self._outgoing: List[Edge] = []
        self._routing_table: Dict[int, int] = {} # Mapping from destination id_ to outgoing index

    def route_to(self, destination: int) -> int:
        return self._outgoing[self._routing_table[destination]].end.id_

    @property
    def pos(self) -> Point:
        return self._pos

    def add_incoming(self, e: Edge) -> None:
        self._incoming.append(e)

    def add_outgoing(self, e: Edge) -> None:
        self._outgoing.append(e)

    @staticmethod
    def from_json(json: Any) -> Node:
        if json["type"] == "junction":
            return Junction.from_json(json)
        if json["type"] == "depot":
            return Depot.from_json(json)
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

    def __init__(self, id_: int, pos: Point, size: int = 10, cooldown: float = 5) -> None:
        super().__init__(id_, pos)
        self._storage: Dict[int,Truck] = {}
        self._storage_size = size
        self._max_cooldown = cooldown
        self._current_cooldown = 0.0

    def entry(self, truck: Truck) -> None:
        if truck.done():
            return
        super().entry(truck)
        self._storage[truck.id_] = truck
        # TODO(mark) no space
        if len(self._storage) > self._storage_size:
            pass

    def act(self, action: Optional[float], dt: float) -> None:
        """ Release the truck with id: action
        """
        if action is None:
            return
        if dt > self._current_cooldown:
            tid = int(action)
            if tid in self._storage:
                truck = self._storage.pop(tid)
                # bodge, need to have a discussion about having both a 'storage' and '_trucks'
                self._trucks = deque(filter(lambda t: t.id_ != tid, self._trucks))
                self._outgoing[self._routing_table[truck.destination]].entry(truck)
                self._current_cooldown += self._max_cooldown

    def update(self, dt: float) -> None:
        self._current_cooldown = max(0, self._current_cooldown - dt)
        for truck in self._storage.values():
            truck.set_velocity(0)

    def compute_actions(self, truck_size: int = 2, safety_margin: int = 5) -> Optional[float]:
        for truck in self._storage.values():
            if truck.start_time >= Config.get_instance().SIM_TIME:
                continue
            if not truck.done(): #Truck is waiting to be released
                next_road = self._outgoing[0]
                if len(next_road.trucks) == 0:
                    return float(truck.id_)

                first_car_pos = next_road.get(0).position * next_road.length # type: ignore
                if first_car_pos > float(truck_size + safety_margin): #There is space on the road
                    #Release this truck
                    return float(truck.id_)
        return None

    @staticmethod
    def from_json(json: Any) -> Depot:
        return Depot(json["id"], Point.from_json(json["position"]))

    def draw(self, screen: pygame.Surface) -> None:
        DEPOT_RADIUS = 10

        pygame.draw.circle(screen, "blue", self.pos.to_tuple(), DEPOT_RADIUS)

        text_surface = DEFAULT_FONT.render('D', False, (255, 255, 255))
        text_rect = text_surface.get_rect(center=self.pos.to_tuple())
        screen.blit(text_surface, text_rect)

        for _ in self._trucks:
            pygame.draw.circle(screen, "green", self.pos.to_tuple(), 2)

class Road(Edge):
    """One way road.
    """

    def __init__(self, id_: int, start: Node, end: Node, length: float) -> None:
        """Initializes a road object

        Args:
            start:
            end:
        """
        super().__init__(id_, start, end)

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
                truck.on_movement(dt)
        for i, truck in enumerate(self._trucks):
            if i+1 < len(self._trucks) and self.get(i+1).position > truck.position:
                truck.collision(self.get(i+1))
                self.get(i+1).collision(truck)
        while len(self._trucks) > 0:
            if self.get(0).position > 1:
                truck = self._trucks.pop()
                truck.position = (truck.position-1) * self._length
                self._end.entry(truck)
            else:
                break

    @property
    def length(self) -> float:
        return self._length

    def draw(self, screen: pygame.Surface) -> None:
        pygame.draw.line(screen, "black",
                         self._start.pos.to_tuple(), self._end.pos.to_tuple(),
                         width=5)
        for truck in self._trucks:
            pygame.draw.circle(screen, "green", self.getPosition(truck.position).to_tuple(), 5)
