from __future__ import annotations
from typing import TYPE_CHECKING
from .truck import Truck
from .graph import Node, Road, Edge, Junction
from .entity import Actor
if TYPE_CHECKING:
    from ..config import Config
    from typing import Dict, List

class Realm:
    def __init__(self, config: Config) -> None:
        self.trucks: Dict[int, Truck] = {}
        self.actors: Dict[int, Actor] = {}
        self.nodes: Dict[int, Node] = {}
        self.edges: Dict[int, Edge] = {}

        # TODO(mark)
        # Run Floyd-Warshall to creating routing tables for junctions
        self._initialise(config)

    def _initialise(self, config: Config) -> None:

        data = config.data

        # graph
        self.nodes = {n["id"]:Node.from_json(n) for n in data['nodes']}

        for r in data['roads']:
            self.edges[r["id"]] = Road(
                    r["id"],
                    self.nodes[int(r["start_node_id"])],
                    self.nodes[int(r["end_node_id"])],
                    r["length"]
                )

        # TODO(mark) temp
        for k,node in self.nodes.items():
            if isinstance(node, Junction) and node.id==3:
                node._routing_table[4] = 0

        # trucks
        self.trucks = {}
        for t in data["trucks"]:
            truck = Truck.from_json(t, config)
            self.trucks[truck.id] = truck
            self.nodes[t['current_node']].entry(truck)

        # TODO(mark) temp
        for t in self.trucks.values():
            t._velocity = 1

        for truck in self.trucks.values():
            self.actors[truck.id] = truck
        for node in self.nodes.values():
            if isinstance(node, Actor):
                self.actors[node.id] = node
        for edge in self.edges.values():
            if isinstance(edge,Actor):
                self.actors[edge.id] = edge

    def update(self, actions: Dict[int, float], dt: float =1/30) -> Dict[Truck, bool]:
        """
        Runs logic.

        Args:
            actions: list of agent actions

        Returns:
            dead: list of destroyed trucks
        """
        # Take actions
        for actor in self.actors.values():
            if actor.id in actions:
                actor.act(actions[actor.id], dt)
            else:
                actor.act(None, dt)

        # Step nodes and roads
        for node in self.nodes.values():
            node.update(dt)
        for edge in self.edges.values():
            edge.update(dt)

        #TODO(mark) completed trucks (finished desired route)
        return {}
