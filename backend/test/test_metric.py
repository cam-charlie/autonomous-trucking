#pylint: disable=protected-access, wrong-import-position
import unittest
import os
import sys
sys.path.append(os.getcwd())
from simulation.env import Env
from simulation.realm.entity import Actions


env = Env()
class TestMetric(unittest.TestCase):
    def test_movement_metric(self) -> None:
        env.reset("test/test_json/test_2.json")
        _,reward,_,_ = env.step(None)
        self.assertEqual(reward,0)
        actions = Actions({}, {10000: 1.0})
        _,reward,_,_ = env.step(actions)
        self.assertGreater(reward,0)

    def test_completion_metric(self) -> None:
        env.reset("test/test_json/test_2.json")
        actions = Actions({}, {10001: 100})
        
        while True:
            _,reward, dones,_ = env.step(actions)
            if dones[10001]:
                self.assertGreater(reward, 10)
                break

if __name__ == "__main__":
    unittest.main()
