#pylint: disable=protected-access, wrong-import-position
import unittest
import os
import sys
sys.path.append(os.getcwd())
from simulation.env import Env

env = Env()
class TestMetric(unittest.TestCase):
    def test_movement_metric(self) -> None:
        env.reset_from_path("test/test_json/test_2.json")
        _,reward,_,_ = env.step({})
        self.assertEqual(reward,0)
        _,reward,_,_ = env.step({10000: 1})
        self.assertGreater(reward,0)

    def test_completion_metric(self) -> None:
        env.reset_from_path("test/test_json/test_2.json")
        while True:
            _,reward, dones,_ = env.step({10001: 100})
            if dones[10001]:
                self.assertGreater(reward, 10)
                break

if __name__ == "__main__":
    unittest.main()
