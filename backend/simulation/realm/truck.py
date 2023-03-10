from __future__ import annotations
from .entity import Actor, Actions
from ..config import Config
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from typing import Any, List, Dict, Optional
    from .graph import TruckContainer
    from .realm import Realm

class Truck(Actor):

    def __init__(self, id_: int, route: List[int], start_time: float) -> None:
        super().__init__(id_)
        self._velocity: float = 0
        self.acceleration: float = 0
        self.position: float = 0
        self._stepped = False
        self._route = route
        self._route_index = 0
        self.start_time = start_time

    def act(self, actions: Actions, dt: float) -> None:
        """Apply actions

        Called once each turn, before step()
        """
        self._stepped = False
        if self.id_ not in actions.truck_accelerations:
            return
        self.acceleration = actions.truck_accelerations[self.id_]


    def update_position(self, dt: float, road_length: float) -> None:
        # Taylor series approximation may make the velocity negative,
        # which breaks the intelligent driver model
        # So do not permit velocity < 0
        if self.velocity + self.acceleration * dt < 0:
            self.position -= (1/2 * self.velocity * self.velocity / self.acceleration) / road_length
            self._velocity = 0
        else:
            self._velocity += self.acceleration * dt
            self.position += (self.velocity*dt + self.acceleration*dt*dt/2) / road_length

    def set_velocity(self, velocity: float) -> None:
        self._velocity = velocity

    def reached_next_destination(self) -> None:
        self._route_index += 1
        assert self._route_index <= len(self._route)
        if self.done():
            self._accumulated_reward += Config.get_instance().COMPLETION_REWARD
            self._accumulated_info.append("Completed Journey")

    def done(self) -> bool:
        return self._route_index >= len(self._route)

    def set_current_truck_container(self, truck_container: TruckContainer) -> None:
        self._current_truck_container = truck_container

    def compute_complete_route(self, realm: Realm) -> None:
        i = 0
        complete_route: List[int] = [self._current_truck_container.id_]
        if complete_route[0] in realm.edges.keys():
            complete_route[0] = realm.edges[complete_route[0]].start.id_
        while i < len(self._route):
            destination = self._route[i]
            current = complete_route[-1]
            if current == destination:
                i += 1
                continue
            complete_route.append(realm.nodes[current].route_to(destination))
        self._route = complete_route
        self._route_index = 1

    def collision(self, o: Truck) -> None:
        self._accumulated_reward += Config.get_instance().COLLISION_REWARD
        self._accumulated_info.append(f"Collision {o.id_}")

    def tailgating(self, o: Truck) -> None:
        self._accumulated_reward += Config.get_instance().TAILGATE_REWARD
        self._accumulated_info.append(f"Tailgating {o.id_}")

    def on_movement(self, dt: float) -> None:
        self._stepped = True
        self._accumulated_reward += self._velocity * Config.get_instance().MOVEMENT_REWARD * dt

    @property
    def stepped(self) -> bool:
        return self._stepped

    @property
    def current_truck_container(self) -> TruckContainer:
        return self._current_truck_container

    @property
    def destination(self) -> int:
        if self.done():
            return -1
        return self._route[self._route_index]

    @property
    def velocity(self) -> float:
        """ Change in normalized position
        """
        return self._velocity

    @property
    def route(self) -> List[int]:
        return self._route

    def to_json(self) -> Dict[Any, Any]:
        return {
            "id": self.id_,
            "current_node": self.current_truck_container.id_,
            "current_position": self.position,
            "route": self.route[self._route_index:],
            "start_time": self.start_time
        }

    @staticmethod
    def from_json(json: Any) -> Truck:
        truck = Truck(int(json["id"]), [int(x) for x in json["route"]], float(json["start_time"]))
        truck.position = json['current_position']
        return truck
