from __future__ import annotations
from abc import ABC, abstractmethod
from simulation.draw.utils import Drawable, DEFAULT_FONT
import pygame
from ..lib.geometry import Point
from ..config import InvalidConfiguration, Config
from .entity import Actor, Entity, Actions
from collections import OrderedDict
from typing import TYPE_CHECKING
import sys
import math

if TYPE_CHECKING:
    from .truck import Truck
    from typing import List, Dict, Any, Optional, Deque

class TruckContainer(Entity, Drawable, ABC):

    def __init__(self, id_: int) -> None:
        super().__init__(id_)
        self._trucks: OrderedDict[int, Truck] = OrderedDict()

    def get_first_truck(self) -> Optional[Truck]:
        return next(iter(self._trucks.values()), None)

    def is_empty(self) -> bool:
        return len(self._trucks) == 0

    def update(self, dt: float) -> None:
        pass

    def entry(self, truck: Truck) -> None:
        """ A new truck has generated / entered this data structure

        Args:
            truck: the new truck.
                Invariant: truck position is normalized
        """
        self._trucks[truck.id_] = truck
        truck.set_current_truck_container(self)

        if truck.destination == self.id_:
            truck.reached_next_destination()
        if truck.done():
            truck._accumulated_reward += 1

    @property
    def id_(self) -> int:
        return self._id

    def trucks(self) -> List[Truck]:
        return list(self._trucks.values())

    @abstractmethod
    def to_json(self) -> Dict[Any, Any]:
        raise NotImplementedError

class Edge(TruckContainer, ABC):

    def __init__(self, id_: int, start: Node, end: Node, length: float) -> None:
        super().__init__(id_)
        start.add_outgoing(self)
        end.add_incoming(self)
        self._start: Node = start
        self._end: Node = end
        self._length: float = length
        self._cost: float = length

    @property
    def cost(self) -> float:
        return self._cost

    @property
    def start(self) -> Node:
        return self._start

    @property
    def end(self) -> Node:
        return self._end

    @property
    def length(self) -> float:
        return self._length

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

    def __init__(self, id_: int, pos:Point, traffic_interval : float = 15) -> None:
        super().__init__(id_, pos)
        self._interval = traffic_interval
        self._timer = traffic_interval
        self._green : int = 0


    def entry(self, truck: Truck) -> None:
        super().entry(truck)
        if truck.done():
            raise InvalidConfiguration()
        self._trucks.pop(truck.id_)
        self._outgoing[self._routing_table[truck.destination]].entry(truck)

    def to_json(self) -> Dict[Any, Any]:
        return {
            "type": "junction",
            "id": self.id_,
            "position": self.pos.to_json()
        }

    def update(self, dt: float) -> None:
        if len(self._incoming) > 1: #There are multiple incoming roads
            self._timer -= dt
            if self._timer < 0:
                #Switch incoming road
                self._timer += self._interval
                self._green = (self._green + 1) % len(self._incoming)

    def green_in(self, dt: float) -> Edge:
        #Returns the edge that will be allowed to enter the junction (green) in dt seconds
        ans = self._green
        if dt > self._timer:
            ans += int((dt - self._timer) / self._interval)
            ans = ans % len(self._incoming)
        return self._incoming[ans]


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
        self._storage_size = size
        self._max_cooldown = cooldown
        self._current_cooldown = 0.0

    def entry(self, truck: Truck) -> None:
        if truck.done():
            return
        super().entry(truck)
        truck.set_velocity(0)
        truck.position = 0
        # TODO(mark) no space
        if len(self._trucks) > self._storage_size:
            pass

    def act(self, actions: Actions, dt: float) -> None:
        """ Release the truck with id: action
        """
        if self.id_ not in actions.trucks_to_release:
            return
        if dt <= self._current_cooldown:
            return
        tid_to_release = actions.trucks_to_release[self.id_]
        if tid_to_release in self._trucks:
            truck = self._trucks.pop(tid_to_release)
            truck.set_velocity(0)
            self._outgoing[self._routing_table[truck.destination]].entry(truck)
            self._current_cooldown += self._max_cooldown


    def update(self, dt: float) -> None:
        self._current_cooldown = max(0, self._current_cooldown - dt)
        for truck in self._trucks.values():
            truck.set_velocity(0)

    def compute_actions(self, truck_size: int = 2, safety_margin: int = 5) -> Optional[int]:
        for truck in self._trucks.values():
            if truck.start_time >= Config.get_instance().SIM_TIME:
                continue
            if not truck.done(): #Truck is waiting to be released
                next_road = self._outgoing[0]
                if next_road.is_empty():
                    return truck.id_

                first_car_pos = next_road.get_first_truck().position * next_road.length # type: ignore
                if first_car_pos > float(truck_size + safety_margin): #There is space on the road
                    #Release this truck
                    return truck.id_
        return None

    def to_json(self) -> Dict[Any, Any]:
        return {
            "type": "depot",
            "id": self.id_,
            "position": self.pos.to_json()
        }

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

    def __init__(self, id_: int, start: Node, end: Node, length: float,
                  speed_limit: float = 31.3) -> None:
        """Initializes a road object

        Args:
            start:
            end:
        """
        super().__init__(id_, start, end, length)

        self._speed_limit = speed_limit
        self._cost = length / speed_limit
        self.did_a_reset = False

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
        for truck in self._trucks.values():
            if not truck.stepped:
                truck.update_position(dt, self.length)
                truck.on_movement(dt)

        # THIS IS PURELY TO DEMONSTRATE THE RUBBER/ELASTIC-BANDING EFFECT
        if round(Config.get_instance().SIM_TIME,5) == 35.0 and not self.did_a_reset:
            print("resetting one")
            for t in self._trucks.values():
                if t.id_ == 10000:
                   t._velocity = 0
            self.did_a_reset = True

        truck_list = self.trucks()
        for i, truck in enumerate(truck_list):
            if i+1 < len(truck_list) and truck_list[i+1].position > truck.position:
                print(f"collision between {truck_list[i].id_,} and {truck_list[i+1].id_} :(")
                sys.exit()
                truck.collision(truck_list[i+1])
                truck_list[i+1].collision(truck)
                truck_list[i+1].position = max(0, truck.position - 3 / self.length)


        #mypy won't correctly type the walrus operator, so ignore
        while (truck := self.get_first_truck()) is not None and truck.position > 1: # type: ignore
            print("moving onto new road!")
            self._trucks.pop(truck.id_)
            truck.position = (truck.position-1) * self._length
            self._end.entry(truck)


    def to_json(self) -> Dict[Any, Any]:
        return {
            "id": self.id_,
            "start_node_id": self._start.id_,
            "end_node_id": self._end.id_,
            "length": self.length
        }


    @property
    def end_node(self) -> Node:
        return self._end

    @property
    def speed_limit(self) -> float:
        return self._speed_limit

    def draw(self, screen: pygame.Surface) -> None:
        pygame.draw.line(screen, "black",
                         self._start.pos.to_tuple(), self._end.pos.to_tuple(),
                         width=5)
        for truck in self._trucks.values():
            pygame.draw.circle(screen, "green", self.getPosition(truck.position).to_tuple(), 5)

    def compute_actions(self, safety_margin: int, truck_accelerations: Dict[int, float]) -> None:
        """
        Computes the actions for each truck (the acceleration for the next timestep).
        Implements the Intelligent Driver Model Specified here:
        - https://journals.aps.org/pre/abstract/10.1103/PhysRevE.62.1805
        - https://towardsdatascience.com/simulating-traffic-flow-in-python-ee1eab4dd20f
        """
        # reversed so truck_list[-1] = furthest ahead truck
        truck_list = list(reversed(self.trucks()))
        #print(f"road {self.id_} has trucks: {[t.id_ for t in truck_list]}")
        for i in range(len(truck_list)-1,-1,-1):
            cur_truck = truck_list[i]
            alpha = 0.0
            if i != len(truck_list)-1:
                next_truck = truck_list[i+1]
                delta_x = self.length * (next_truck.position - cur_truck.position) - 4 # subtract 4 (truck length)
                delta_v = cur_truck.velocity - next_truck.velocity
                #print(f"Distances between {cur_truck.id_} and {next_truck.id_} = {delta_x}")
                sqrt_ab = 2 * math.sqrt(Config.get_instance().MAX_ACCELERATION * Config.get_instance().COMFORTABLE_DECELERATION)
                alpha = (Config.get_instance().MIN_DESIRED_DIST + max(0, delta_v*cur_truck.velocity/sqrt_ab)) / delta_x

            truck_accelerations[cur_truck.id_] = Config.get_instance().MAX_ACCELERATION * \
                                                (1 - (cur_truck.velocity / Config.get_instance().MAX_VELOCITY)**Config.get_instance().ACCELERATION_SMOOTHNESS \
                                                    - alpha**2
                                                )



        '''
        truck_list = self.trucks()
        for i in range(len(truck_list)-1,-1,-1):
            this_truck = truck_list[i]
            if i == len(truck_list)-1: #no truck in front of it: eventually going into a node
                if type(self.end_node) is Junction:
                    next_node = self.end_node
                    #Work out how long before we hit the junction
                    distance = (1-this_truck.position) * self.length
                    if this_truck.velocity > 0:
                        #Truck is moving
                        time = distance / this_truck.velocity

                        if next_node.green_in(time) == self:
                            #print(this_truck.id_)
                            #Currently headed for a green light
                            if this_truck.velocity < Config.get_instance().MAX_VELOCITY and this_truck.velocity < self.speed_limit:
                                #Accelerate
                                truck_accelerations[this_truck.id_] = Config.get_instance().MAX_ACCELERATION
                        else: #Currently headed for a red light
                            #Work out safe stopping distance - basically the same as below but with v = 0 as we want a complete stop
                            u = this_truck.velocity
                            v = 0.0
                            a = Config.get_instance().MAX_ACCELERATION * (-1)

                            relative_stopping_distance = ((v * v) - (u * u)) / (2 * a) + safety_margin #SUVAT

                            if distance < relative_stopping_distance:
                                #Too close! Deccelerate
                                truck_accelerations[this_truck.id_] = Config.get_instance().MAX_ACCELERATION * (-1)
                            elif distance > relative_stopping_distance and this_truck.velocity < Config.get_instance().MAX_VELOCITY and this_truck.velocity < self.speed_limit:
                                #There's space - accelerate
                                truck_accelerations[this_truck.id_] = Config.get_instance().MAX_ACCELERATION
                    else:
                        #Truck is not moving
                        if distance > safety_margin or next_node.green_in(0) == self:
                            #Over the safety margin or the light is green = start to move towards the junction
                            truck_accelerations[this_truck.id_] = Config.get_instance().MAX_ACCELERATION

                else:
                    if this_truck.velocity < Config.get_instance().MAX_VELOCITY and this_truck.velocity < self.speed_limit:
                        #Accelerate
                        truck_accelerations[this_truck.id_] = Config.get_instance().MAX_ACCELERATION

            else: #There is a truck in front
                next_truck = truck_list[i+1]
                #Generate stopping distance
                u = this_truck.velocity
                v = next_truck.velocity
                a = Config.get_instance().MAX_ACCELERATION * (-1)
                relative_stopping_distance = ((v * v) - (u * u)) / (2 * a) + safety_margin #SUVAT

                distance = (next_truck.position - this_truck.position) * self.length

                if distance < relative_stopping_distance:
                    #Too close! Deccelerate
                    truck_accelerations[this_truck.id_] = float(Config.get_instance().MAX_ACCELERATION * (-1))
                    #print("Truck " + str(this_truck.id_) + ": Decelerate #5")
                elif distance > relative_stopping_distance and this_truck.velocity < Config.get_instance().MAX_VELOCITY and this_truck.velocity < self.speed_limit:
                    #There's space - accelerate
                    truck_accelerations[this_truck.id_] = float(Config.get_instance().MAX_ACCELERATION)
                    #print("Truck " + str(this_truck.id_) + ": Accelerate #5")
        #print(truck_accelerations)
        '''