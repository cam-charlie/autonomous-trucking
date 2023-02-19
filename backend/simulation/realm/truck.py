from __future__ import annotations
from .entity import Actor
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from typing import Any, List
    from ..config import Config

class Truck(Actor):

    def __init__(self, route: List[int], config: Config):
        super().__init__()
        self._velocity: float = 0
        self.destination: int = route[0]
        self.position: float = 0
        self.stepped = False
        self.config = config
        self._route = route


    def act(self, acceleration, dt) -> None:
        """Apply actions

        Called once each turn, before step()
        """
        self.stepped = False
        if acceleration != None:
            achieved_acceleration = min(self.config.MAX_ACCELERATION, abs(acceleration))
            if acceleration < 0:
                achieved_acceleration = achieved_acceleration * -1
            self._velocity = min(self.config.MAX_VELOCITY, self._velocity + achieved_acceleration*dt)
            if self._velocity < 0:
                self._velocity = 0

    @property
    def velocity(self) -> float:
        """ Change in normalized position
        """
        return self._velocity

    @property
    def route(self) -> List[int]:
        return self._route

    @staticmethod
    def from_json(json: Any, config: Config) -> 'Truck':
        truck = Truck([int(x) for x in json["route"]], config)
        truck.position = json['current_position']
        return truck


class Collision(Exception):
    pass
