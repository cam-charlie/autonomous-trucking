from simulation.globals import MAX_ACCELERATION, MAX_VELOCITY


from typing import Any, List


class Truck:

    def __init__(self, id: int, destination_id: int, route: List[int]):
        self._id = id
        self._velocity: float = 0
        self.destination: int = destination_id
        self.position: float = 0
        self.stepped = False

        self._route = route

    def update(self, acceleration: float, dt: float) -> None:
        """Apply actions

        Called once each turn, before step()
        """
        self.stepped = False
        acceleration = max(MAX_ACCELERATION, abs(acceleration))
        self._velocity = max(MAX_VELOCITY, self._velocity + acceleration*dt)

    @property
    def id(self) -> int:
        """ Unique
        """
        return self._id

    @property
    def velocity(self) -> float:
        """ Change in normalized position
        """
        return self._velocity

    @property
    def route(self) -> List[int]:
        return self._route

    @staticmethod
    def from_json(json: Any) -> 'Truck':
        return Truck(int(json["truck_id"]), int(json["destination_id"]), [int(x) for x in json["route"]])


class Collision(Exception):
    pass
