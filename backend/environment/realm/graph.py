from __future__ import annotations
from abc import ABC, abstractmethod

from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from environment.config import Config
    from environment.realm.truck import Truck
    from typing import List

class TruckContainer(ABC):
    def __init__(self):
        self._trucks: List[Truck] = []

    def step():
        pass

class Edge(TruckContainer, ABC):
    pass

class Node(TruckContainer, ABC):
    pass

class Road(Edge):
    pass