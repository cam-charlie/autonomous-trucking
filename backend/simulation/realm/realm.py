from __future__ import annotations
import math
from typing import TYPE_CHECKING
from .truck import Truck
from .graph import Node, Road, Edge, Junction
from .entity import Actor
if TYPE_CHECKING:
    from ..config import Config
    from typing import Dict, List, Tuple

class Realm:
    def __init__(self, config: Config) -> None:
        self.trucks: Dict[int, Truck] = {}
        self.actors: Dict[int, Actor] = {}
        self.nodes: Dict[int, Node] = {}
        self.edges: Dict[int, Edge] = {}
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

        # Run Floyd-Warshall
        distance: Dict[Tuple[int,int],float] = {} # Distance
        direction: Dict[Tuple[int,int],int] = {} # Next path to take
        for i, edge in enumerate(self.edges.values()):
            distance[(edge._start.id,edge._end.id)] = edge.cost
            direction[(edge._start.id,edge._end.id)] = i
        for node in self.nodes.values():
            distance[(node.id,node.id)] = 0
            direction[(node.id,node.id)] = -1
        for k in self.nodes.values():
            for s in self.nodes.values():
                for d in self.nodes.values():
                    if distance.get((s.id,d.id),math.inf) > distance.get((s.id,k.id),math.inf) + distance.get((k.id,d.id),math.inf):
                        distance[(s.id,d.id)] = distance[(s.id,k.id)] + distance[(k.id,d.id)]
                        direction[(s.id,d.id)] = direction[(s.id,k.id)]
            # Put direction into routing table format
        for s in self.nodes.values():
            for d in self.nodes.values():
                if (s.id,d.id) in direction and direction[(s.id,d.id)] != None:
                    s._routing_table[d.id] = direction[(s.id,d.id)]

        # trucks
        self.trucks = {}
        for t in data["trucks"]:
            truck = Truck.from_json(t, config)
            self.trucks[truck.id] = truck
            self.nodes[t['current_node']].entry(truck)
            
        for truck in self.trucks.values():
            self.actors[truck.id] = truck
        for node in self.nodes.values():
            if isinstance(node, Actor):
                self.actors[node.id] = node
        for edge in self.edges.values():
            if isinstance(edge,Actor):
                self.actors[edge.id] = edge

    def update(self, actions: Dict[int, float], dt: float =1/30) -> Dict[int, bool]:
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

        dones = {truck.id: truck.done() for truck in self.trucks.values()}
        return dones
