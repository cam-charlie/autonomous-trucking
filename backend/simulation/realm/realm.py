from __future__ import annotations

from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from simulation.config import Config
    from simulation.realm.truck import Truck
    from simulation.realm.graph import TruckContainer
    from typing import Dict

class Realm:
    def __init__(self, config: Config) -> None:
        self.config = config
        self.trucks: Dict[int, Truck] = {}
        self.graph: Dict[int, TruckContainer] = {}

        # TODO(mark) initialize trucks and graph from config
        # 1. Generate graph structure
        # 2. Run Floyd-Warshall to creating routing tables for junctions

    def step(self, actions: Dict[int, float], dt: float =1/30) -> None:
        """
        Runs logic.

        Args:
            actions: list of agent actions
        
        Returns:
            dead: list of destroyed trucks
        """

        # Update accelerations
        for truck in self.trucks.values():
            truck.update(actions[truck.id],dt)

        # Step
        for node in self.graph.values():
            node.step(dt)

        #TODO(mark) completed trucks (finished desired route)
