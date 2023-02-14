from __future__ import annotations

from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from environment.config import Config
    from environment.realm.truck import Truck
    from environment.realm.graph import *
    from typing import List, Dict

class Realm:
    
    def __init__(self, config: Config):
        self.config = config
        self.trucks: Dict[int, Truck] = {}
        self.graph: Dict[int, TruckContainer] = {}
    
        #TODO(mark) initialize trucks and graph from config

    def step(self, actions: Dict[int, float], dt: float =1/30):
        """
        Runs logic.

        Args:
            actions: list of agent actions
        
        Returns:
            dead: 
                list of destroyed trucks
        """

        # Update accelerations
        for truck in self.trucks:
            truck.update(actions[truck.id])

        # Step 
        for node in self.graph.values():
            node

        #TODO(mark) completed trucks (finished desired route)