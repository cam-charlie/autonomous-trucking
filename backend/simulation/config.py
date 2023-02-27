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
