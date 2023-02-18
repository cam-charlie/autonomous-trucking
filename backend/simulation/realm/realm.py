from __future__ import annotations
import json

from typing import TYPE_CHECKING
from simulation.realm.truck import Truck
from simulation.realm.graph import Road, Node, Edge, Junction
if TYPE_CHECKING:
    from simulation.realm.graph import TruckContainer
    from typing import Dict

class Realm:
    def __init__(self) -> None:
        self.trucks: Dict[int, Truck] = {}
        self.nodes: Dict[int, Node] = {}
        self.roads: Dict[int, Road] = {}

        # TODO(mark) initialize trucks and graph from config
        # 1. Generate graph structure
        # 2. Run Floyd-Warshall to creating routing tables for junctions
        self._initialise("../shared/example.json")

    def _initialise(self, config_path: str) -> None:
        with open(config_path, 'r') as f:
            data = json.load(f)

        self.trucks = {t["truck_id"]: Truck.from_json(t) for t in data["trucks"]}


        for n in data["nodes"]:
            self.nodes[n["node_id"]] = Node.from_json(n)

        for r in data["roads"]:
            self.roads[r["road_id"]] = Road(
                r["road_id"],
                self.nodes[int(r["start_node_id"])],
                self.nodes[int(r["end_node_id"])],
                r["length"]
            )

        # bodge
        for node in self.nodes.values():
            if isinstance(node, Junction) and node.id==3:
                node._routing_table[4] = 0

        # add trucks to the first container on their route
        for truck in self.trucks.values():
            self.nodes[truck.route[0]].entry(truck)


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

        # Step nodes and roads
        for node in self.nodes.values():
            node.step(dt)
        for road in self.roads.values():
            road.step(dt)


        #TODO(mark) completed trucks (finished desired route)
