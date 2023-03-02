from __future__ import annotations
import math
from typing import TYPE_CHECKING
from .truck import Truck
from .graph import Node, Road, Edge
from .entity import Actor
from ..config import Config
if TYPE_CHECKING:
    from typing import Dict, List, Tuple

class Realm:
    def __init__(self) -> None:
        self.trucks: Dict[int, Truck] = {}
        self.actors: Dict[int, Actor] = {}
        self.nodes: Dict[int, Node] = {}
        self.edges: Dict[int, Edge] = {}
        self.initialise()

    def initialise(self) -> None:
        #pylint: disable=protected-access

        data = Config.get_instance().data

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
        for edge in self.edges.values():
            distance[(edge.start.id_,edge.end.id_)] = edge.cost
            direction[(edge.start.id_,edge.end.id_)] = edge.start._outgoing.index(edge)
        for node in self.nodes.values():
            distance[(node.id_,node.id_)] = 0
            direction[(node.id_,node.id_)] = -1
        for k in self.nodes.values():
            for s in self.nodes.values():
                for d in self.nodes.values():
                    if distance.get((s.id_,d.id_),math.inf) > \
                        distance.get((s.id_,k.id_),math.inf) + distance.get((k.id_,d.id_),math.inf):
                        distance[(s.id_,d.id_)] = distance[(s.id_,k.id_)] + distance[(k.id_,d.id_)]
                        direction[(s.id_,d.id_)] = direction[(s.id_,k.id_)]
            # Put direction into routing table format

        for s in self.nodes.values():
            for d in self.nodes.values():
                if (s.id_,d.id_) in direction and direction[(s.id_,d.id_)] is not None:
                    s._routing_table[d.id_] = direction[(s.id_,d.id_)]

        # trucks
        self.trucks = {}
        for t in data["trucks"]:
            truck = Truck.from_json(t)
            self.trucks[truck.id_] = truck
            self.nodes[t['current_node']].entry(truck)

        for truck in self.trucks.values():
            self.actors[truck.id_] = truck
        for node in self.nodes.values():
            if isinstance(node, Actor):
                self.actors[node.id_] = node
        for edge in self.edges.values():
            if isinstance(edge,Actor):
                self.actors[edge.id_] = edge

    def update(self, actions: Dict[int, float], dt: float) -> Dict[int, bool]:
        """
        Runs logic.

        Args:
            actions: list of agent actions

        Returns:
            dead: list of destroyed trucks
        """
        # Take actions
        for actor in self.actors.values():
            if actor.id_ in actions:
                actor.act(actions[actor.id_], dt)
            else:
                actor.act(None, dt)

        # Step nodes and roads
        for node in self.nodes.values():
            node.update(dt)
        for edge in self.edges.values():
            edge.update(dt)

        dones = {truck.id_: truck.done() for truck in self.trucks.values()}
        return dones
