import json
from typing import Optional

class InvalidConfiguration(Exception):
    pass

class ConfigNotInitialised(Exception):
    pass

class ConfigIsSingleton(Exception):
    pass

class Config:

    _INSTANCE: Optional['Config'] = None

    def __init__(self, json_str: str, from_path: bool = False) -> None:
        if Config._INSTANCE is not None:
            raise ConfigIsSingleton

        if from_path: # json_str represents path
            with open(json_str, 'r',encoding='utf-8') as f:
                self.data = json.load(f)
        else:
            self.data = json.loads(json_str)

        self.SIM_TIME = float(self.data["globals"]["sim_time"])
        self.MAX_ACCELERATION = float(self.data["globals"]["max_truck_acceleration"])
        self.COMFORTABLE_DECELERATION = 3 * self.MAX_ACCELERATION
        self.MAX_VELOCITY = float(self.data["globals"]["max_truck_velocity"])



    @staticmethod
    def get_instance() -> 'Config':
        if Config._INSTANCE is None:
            raise ConfigNotInitialised
        return Config._INSTANCE

    @staticmethod
    def initialise(json_string: str) -> None:
        Config._INSTANCE = Config(json_string)

    @staticmethod
    def initialise_from_path(path: str) -> None:
        Config._INSTANCE = Config(path, True)

    @staticmethod
    def clear() -> None:
        Config._INSTANCE = None

    MIN_DESIRED_DIST = 20
    ACCELERATION_SMOOTHNESS = 4
    TRUCK_LENGTH = 8
    SAFETY_MARGIN_TO_LIGHT = 15

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
