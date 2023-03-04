from __future__ import annotations
from .entity import Actor
from ..config import Config
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from typing import Any, List, Optional
    from .graph import TruckContainer
    from .realm import Realm

class Truck(Actor):

    def __init__(self, id_: int, route: List[int], start_time: float) -> None:
        super().__init__(id_)
        self._velocity: float = 0
        self.position: float = 0
        self._stepped = False
        self._route = route
        self._route_index = 0
        self.start_time = start_time

    def act(self, action: Optional[float], dt: float) -> None:
        """Apply actions

        Called once each turn, before step()
        """
        acceleration = action
        self._stepped = False
        if acceleration is not None:
            achieved_acceleration = min(Config.get_instance().MAX_ACCELERATION, abs(acceleration))
            if acceleration < 0:
                achieved_acceleration = achieved_acceleration * -1
            self._velocity = min(Config.get_instance().MAX_VELOCITY,
                                 self._velocity + achieved_acceleration*dt)
            self._velocity = max(self._velocity, 0)

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

    @staticmethod
    def from_json(json: Any) -> Truck:
        truck = Truck(int(json["id"]), [int(x) for x in json["route"]], float(json["start_time"]))
        truck.position = json['current_position']
        return truck
