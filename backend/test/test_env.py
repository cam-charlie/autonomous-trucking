import unittest
import os
import sys
sys.path.append(os.getcwd())
from simulation.env import Env

class TestEnv(unittest.TestCase):
    def test_setup(self) -> None:
        env = Env()
        env.reset("../shared/example.json")

    def test_rollout_basic(self) -> None:
        env = Env()
        env.reset("test/test_json/test_1.json")

if __name__ == "__main__":
    unittest.main()
