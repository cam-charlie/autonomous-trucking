#pylint: disable=protected-access, wrong-import-position
import unittest
import os
import sys
sys.path.append(os.getcwd())
from simulation.env import Env
from simulation.realm.entity import Actions

env = Env()
class TestEnv(unittest.TestCase):
    def test_setup(self) -> None:
        env.reset_from_path("../shared/example.json")


    def test_rollout_basic(self) -> None:
        env.reset("test/test_json/test_1.json")
        actions = Actions({}, {10001: 10.0})
        for _ in range(128):
            env.step(actions)

    def test_route_completion(self) -> None:
        env.reset_from_path("test/test_json/test_2.json")
        self.assertListEqual(env.realm.trucks[10000]._route,[1,2,3])
        self.assertListEqual(env.realm.trucks[10001]._route,[2,3])

if __name__ == "__main__":
    unittest.main()
