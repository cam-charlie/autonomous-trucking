class Truck:
    # Shared State
    __id: int = 0

    def __init__(self, max_acceleration: float =1.0, max_velocity:float = 1.0) -> None:
        self._id: int = Truck.__id
        Truck.__id += 1

        self._max_acceleration: float = max_acceleration
        self._max_velocity: float = max_velocity
        self.velocity: float = 0
        self.position: float = 0

    def update(self, acceleration: float) -> None:
        #TODO(mark) bounds check
        self.velocity += acceleration