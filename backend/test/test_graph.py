import unittest
import os
import sys
sys.path.append(os.getcwd())
from simulation.lib.geometry import Point
from simulation.realm.graph import Road, Junction
from simulation.realm.truck import Collision, Truck

class TestGraph(unittest.TestCase):
    def test_road_definition(self):
        junction_start = Junction(0, Point(1,1))
        junction_end = Junction(1, Point(2,3))

        test_road_a = Road(2, junction_start,junction_end, 5)

        self.assertAlmostEqual(test_road_a._start.pos.x, 1)
        self.assertAlmostEqual(test_road_a._start.pos.y, 1)
        self.assertAlmostEqual(test_road_a._end.pos.x, 2)
        self.assertAlmostEqual(test_road_a._end.pos.y, 3)


    def test_road_step(self):
        junction_start = Junction(0, Point(0,0))
        junction_next = Junction(1, Point(10,0))
        road = Road(2, junction_start,junction_next, 10)
        t0 = Truck(100, junction_next)
        t0._velocity = 1
        # Step for 5 seconds at constant velocity
        road.entry(t0)
        for _ in range(5):
            t0.update(0, 0)
            road.step(1.0)
        self.assertAlmostEqual(road._trucks[0].position, 0.5)
        # Collision
        t1 = Truck(101, junction_next)
        t1._velocity = 1
        t2 = Truck(102, junction_next)
        t2._velocity = 3
        road.entry(t1)
        t1.update(0,0)
        road.step(1.0)
        road.entry(t2)
        t1.update(0,0)
        t2.update(0,0)
        road.step(0.01)
        t1.update(0,0)
        t2.update(0,0)
        self.assertRaises(Collision, road.step, 1.0)


    def test_junction_continuation(self):
        junction_start = Junction(0, Point(0,0))
        junction_test = Junction(1, Point(0,5))
        junction_end = Junction(2, Point(0,10))
        road_start = Road(3, junction_start, junction_test, 5)
        road_end = Road(4, junction_test, junction_end, 5)
        junction_test._routing_table[junction_end.id] = 0
        t = Truck(100, junction_end.id)
        t._velocity = 2

        road_start.entry(t)
        for _ in range(3):
            t.update(0,0)
            road_start.step(1)
            road_end.step(1)

        self.assertAlmostEqual(road_end._trucks[0].position, 0.2)
        self.assertEqual(len(road_start._trucks),0)


if __name__ == "__main__":
    unittest.main()