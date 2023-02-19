'''
2D vector representation. Use immutably.
'''
from typing import Any, Tuple

class Point:

    def __init__(self, x: float,y: float) -> None:
        self._x = x
        self._y = y

    @property
    def x(self) -> float:
        return self._x

    @property
    def y(self) -> float:
        return self._y

    def __add__(self, o):
        return Point(self.x+o.x, self.y+o.y)

    def __sub__(self, o):
        return Point(self.x-o.x, self.y-o.y)

    def __mul__(self, l: float):
        return Point(self.x*l, self.y*l)

    def magnitude(self) -> float:
        return (self.x**2 + self.y**2)**0.5

    def __str__(self):
        return "({} {})".format(self.x, self.y)

    @staticmethod
    def from_json(json: Any) -> 'Point':
        return Point(float(json['x']), float(json['y']))

    def to_tuple(self) -> Tuple[float, float]:
        return (self.x, self.y)
