from __future__ import annotations
from .config import Config
from .realm.realm import Realm

from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from typing import Dict, Tuple, Any
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

    def reset(self, config_json_path: str) -> EnvState:
        """ Reset realm to map and conditions specified in config

        Returns:
            observations: As defined in compute observations
            rewards
            dones
            infos
        """
        self.config = Config(config_json_path)
        self.realm = Realm(self.config)

        return self.step()

    def step(self, actions: Dict[int, float] = {}) -> EnvState:
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

        dones = self.realm.update(actions)
        obs = self._compute_observations()
        rewards, infos = self._compute_rewards()

        return obs, rewards, dones, infos


    def _compute_rewards(self) -> Tuple[float, Dict[Any, Any]]:
        """ Computes the metric to optimize for

        By default overall throughput of trucks reaching destination.
        Override to consider different metrics

        Returns
            Change in metric on most recent step
        """
        return 0, {}

    def _compute_observations(self) -> Dict[Any, Any]:
        """Autonomous trucking observation API.

        Returns:
            obs: a representation of the realm suitable for general algorithm optimization.
        """

        # Release primarily truck positions and representation of graph structure.
        # Future lookaheads should be done by the algorithm module.

        # TODO(mark) this is a placeholder. Wrap into a dictionary of primitives.
        return {}

    def render(self) -> float:
        """ Pass required game state to frontend module
        """
        raise NotImplementedError
