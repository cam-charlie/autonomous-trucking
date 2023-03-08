# pylint: disable=dangerous-default-value, attribute-defined-outside-init
from __future__ import annotations
import json
from .config import Config
from .realm.realm import Realm
from .realm.entity import Actions

from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from typing import Any, Dict, List, Tuple, Optional
    EnvState = Tuple[Dict[Any, Any], float, Dict[int, bool], Dict[Any, Any]]

'''
Wrapper for interfacing with algorithm
#TODO(mark) Fully interface with PettingZoo API to run RL as extension :D
'''

class Env:
    """Environment wrapper for autonomous-trucking simulator following format commonly used
    in reinforcement learning settings.
    Also applicable for rule based solutions
    """

    def reset(self, json_string: str) -> EnvState:
        """ Reset realm to map and conditions specified in config
        Returns:
            observations: As defined in compute observations
            rewards
            dones
            infos
        """
        Config.clear()
        Config.initialise(json_string)
        self.realm = Realm()

        return self.step()

    def reset_from_path(self, path: str) -> EnvState:
        """ Reset realm to map and conditions specified in config

        Returns:
            observations: As defined in compute observations
            rewards
            dones
            infos
        """
        Config.clear()
        Config.initialise_from_path(path)
        self.realm = Realm()

        return self.step()

    def step(self, actions: Optional[Actions] = None, dt: float=1/30) -> EnvState:
        """ Simulates one realm tick.
        Args:
            actions: A dictionary of agent decisions of format:
                {
                    agent1: {
                        action1: [*args],
                        action2 ...
                    },
                    agent2 ...
                }
                Where depending on the heterogenous agent type, such as trucks, road, various nodes
                actions can include accelerate, lane switch, release truck etc.
        Returns:
            observations: As defined in _compute observations
            rewards: As defined in _compute_rewards
            dones: A dictionary of agents to booleans, where true indicates truck has completed
                entire route.
            infos: A dictionary of agents to debug information.
        """
        if actions is None:
            actions = Actions({}, {})
        dones = self.realm.update(actions, dt)
        Config.get_instance().SIM_TIME += dt
        obs = self._compute_observations()
        rewards, infos = self._compute_rewards()

        return obs, rewards, dones, infos


    def _compute_rewards(self) -> Tuple[float, Dict[int, List[str]]]:
        """ Computes the metric to optimize for
        By default overall throughput of trucks reaching destination.
        Override to consider different metrics
        Returns
            Change in metric on most recent step
        """
        return self.realm.compute_rewards(), self.realm.compute_infos()

    def _compute_observations(self) -> Dict[Any, Any]:
        """Autonomous trucking observation API.
        Returns:
            obs: a representation of the realm suitable for general algorithm optimization.
        """

        # Release primarily truck positions and representation of graph structure.
        # Future lookaheads should be done by the algorithm module.

        # TODO(mark) this is a placeholder. Wrap into a dictionary of primitives.
        return {}

    def to_json(self) -> str:
        config = Config.get_instance()
        result = {
            "nodes": [
                node.to_json() for node in self.realm.nodes.values()
            ],
            "roads": [
                edge.to_json() for edge in self.realm.edges.values()
            ],
            "trucks": [
                truck.to_json() for truck in self.realm.trucks.values()
            ],
            "globals": {
                "max_truck_acceleration": config.MAX_ACCELERATION,
                "max_truck_velocity": config.MAX_VELOCITY,
                "sim_time": config.SIM_TIME
            }
        }
        return json.dumps(result)
