import json

class InvalidConfiguration(Exception):
    pass

class Config:

    def __init__(self, path: str) -> None:
        with open(path, 'r',encoding='utf-8') as f:
            self.data = json.load(f)

    @property
    def MAX_ACCELERATION(self) -> float:
        return float(self.data["globals"]["max_truck_acceleration"])

    @property
    def MAX_VELOCITY(self) -> float:
        return float(self.data["globals"]["max_truck_velocity"])

    @property
    def COLLISION_REWARD(self) -> float:
        return -100

    @property
    def TAILGATE_REWARD(self) -> float:
        return -1

    @property
    def MOVEMENT_REWARD(self) -> float:
        return 0.001

    @property
    def COMPLETION_REWARD(self) -> float:
        return 10
