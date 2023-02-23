from __future__ import annotations
from .entity import Actor
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from typing import Any, List, Optional
    from ..config import Config

class Truck(Actor):

    def __init__(self, id: int, route: List[int], config: Config) -> None:
        super().__init__(id)
        self._velocity: float = 0
        self.position: float = 0
        self.stepped = False
        self.config = config
        self._route = route[::-1]


    def act(self, acceleration: Optional[float], dt: float) -> None:
        """Apply actions

        Called once each turn, before step()
        """
        self.stepped = False
        if acceleration is not None:
            achieved_acceleration = min(self.config.MAX_ACCELERATION, abs(acceleration))
            if acceleration < 0:
                achieved_acceleration = achieved_acceleration * -1
            self._velocity = min(self.config.MAX_VELOCITY, self._velocity + achieved_acceleration*dt)
            if self._velocity < 0:
                self._velocity = 0

    def reached_next_destination(self) -> None:
        self._route.pop()

    def done(self) -> bool:
        return True if len(self._route) == 0 else False

    @property
    def destination(self) -> int:
        if len(self._route) == 0:
            return -1
        return self._route[-1]

    @property
    def next_container_id(self) -> int:
        if len(self._route) == 0:
            return -1
        else:
            return self._route[0]

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
