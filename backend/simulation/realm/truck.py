from __future__ import annotations
from .entity import Actor
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from typing import Any, List, Optional
    from ..config import Config
    from .graph import TruckContainer

class Truck(Actor):

    def __init__(self, id_: int, route: List[int], config: Config) -> None:
        super().__init__(id_)
        self._velocity: float = 0
        self.position: float = 0
        self.stepped = False
        self.config = config
        self._route = route
        self._route_index = 0

    def act(self, action: Optional[float], dt: float) -> None:
        """Apply actions

        Called once each turn, before step()
        """
        acceleration = action
        self.stepped = False
        if acceleration is not None:
            achieved_acceleration = min(self.config.MAX_ACCELERATION, abs(acceleration))
            if acceleration < 0:
                achieved_acceleration = achieved_acceleration * -1
            self._velocity = min(self.config.MAX_VELOCITY,
                                 self._velocity + achieved_acceleration*dt)
            self._velocity = max(self._velocity, 0)

    def set_velocity(self, velocity: float) -> None:
        self._velocity = velocity

    def reached_next_destination(self) -> None:
        self._route_index += 1

    def done(self) -> bool:
        return self._route_index >= len(self._route)

    def set_current_truck_container(self, truck_container: TruckContainer) -> None:
        self._current_truck_container = truck_container

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
    def from_json(json: Any, config: Config) -> Truck:
        truck = Truck(int(json["id"]), [int(x) for x in json["route"]], config)
        truck.position = json['current_position']
        return truck

class Collision(Exception):
    pass
