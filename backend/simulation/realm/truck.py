from simulation.lib.id import generateID

class Truck:

    def __init__(self, destination: int, max_acceleration: float =1.0, max_velocity:float = 1.0):
        self._id: int = generateID()

        self._max_acceleration: float = max_acceleration
        self._max_velocity: float = max_velocity
        self._velocity: float = 0
        self.destination: int = destination
        self.position: float = 0
        self.stepped = False

    def update(self, acceleration: float, dt: float) -> None:
        """Apply actions

        Called once each turn, before step()
        """
        self.stepped = False
        acceleration = max(self._max_acceleration,acceleration)
        self._velocity = max(self._max_velocity, self._velocity + acceleration*dt)

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

class Collision(Exception):
    pass
