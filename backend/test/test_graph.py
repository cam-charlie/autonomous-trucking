#pylint: disable=protected-access, wrong-import-position, super-init-not-called

import unittest
import os
import sys
sys.path.append(os.getcwd())
from simulation.lib.geometry import Point
from simulation.realm.graph import Depot, Road, Junction
from simulation.realm.truck import Truck
from simulation.realm.entity import Actions
from simulation.config import Config


Config.initialise("test/test_json/test_graph.json")
test_config = Config.get_instance()

class TestGraph(unittest.TestCase):
    def test_road_definition(self) -> None:
        junction_start = Junction(0, Point(1,1))
        junction_end = Junction(1, Point(2,3))

        test_road_a = Road(2, junction_start,junction_end, 5)

        self.assertAlmostEqual(test_road_a._start.pos.x, 1)
        self.assertAlmostEqual(test_road_a._start.pos.y, 1)
        self.assertAlmostEqual(test_road_a._end.pos.x, 2)
        self.assertAlmostEqual(test_road_a._end.pos.y, 3)


    def test_road_step(self) -> None:
        junction_start = Junction(0, Point(0,0))
        junction_next = Junction(1, Point(10,0))
        road = Road(2, junction_start,junction_next, 10)
        t0 = Truck(100,[junction_next.id_], 0.0)
        t0._velocity = 1
        # Step for 5 seconds at constant velocity
        actions = Actions({}, {100:0.0, 101:0.0, 102:0.0})
        road.entry(t0)
        for _ in range(5):
            t0.act(actions, 0)
            road.update(1.0)
        first_truck = road.get_first_truck()
        self.assertIsNotNone(first_truck)
        self.assertAlmostEqual(first_truck.position, 0.5) # type: ignore
        # Collision
        t1 = Truck(101, [junction_next.id_], 0.0)
        t1._velocity = 1
        t2 = Truck(102, [junction_next.id_], 0.0)
        t2._velocity = 3
        road.entry(t1)
        t1.act(actions,0)
        road.update(1.0)
        road.entry(t2)
        t1.act(actions,0)
        t2.act(actions,0)
        road.update(0.01)
        t1.act(actions,0)
        t2.act(actions,0)
        road.update(1.0)
        self.assertLess(t1.get_accumulated_reward(),0)


    def test_junction_continuation(self) -> None:
        junction_start = Junction(0, Point(0,0))
        junction_test = Junction(1, Point(0,5))
        junction_end = Junction(2, Point(0,10))
        road_start = Road(3, junction_start, junction_test, 5)
        road_end = Road(4, junction_test, junction_end, 5)
        junction_test._routing_table[junction_end.id_] = 0
        t = Truck(100, [junction_end.id_], 0.0)
        t._velocity = 2

        road_start.entry(t)
        actions = Actions({}, {100:0.0})
        for _ in range(3):
            t.act(actions,0)
            road_start.update(1)
            road_end.update(1)

        end_truck = road_end.get_first_truck()
        self.assertIsNotNone(end_truck)
        if end_truck is not None:
            self.assertAlmostEqual(end_truck.position, 0.2)
        self.assertEqual(road_start.is_empty(),True)

    def test_depot(self) -> None:
        depot_start = Depot(0, Point(0,0))
        depot_start._routing_table[1] = 0
        depot_end = Depot(1, Point(10,0))

        road = Road(2, depot_start, depot_end, 10)
        t = Truck(100, [depot_end.id_], 0.0)
        t._velocity = 1

        depot_start.entry(t)
        dt = 1
        # Does nothing
        actions = Actions({}, {100:1.0})
        for _ in range(5):
            t.act(actions,dt)
            depot_start.act(actions, dt)
            depot_start.update(dt)
            depot_end.update(dt)
            road.update(dt)
        # Release
        actions.trucks_to_release[depot_start.id_] = t.id_
        for _ in range(100):
            if t.done():
                break
            t.act(actions,dt)
            depot_start.act(actions, dt)
            depot_start.update(dt)
            depot_end.update(dt)
            road.update(dt)
        self.assertTrue(t.done())

if __name__ == "__main__":
    unittest.main()
