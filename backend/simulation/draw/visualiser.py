import pygame
import sys

from simulation.realm.truck import Truck
from simulation.realm.graph import Node, Road
from simulation.realm.realm import Realm

'''
Pygame's coordinate system has (0,0) in the top left corner.
(0,0) ---------> +x
|
|
|
|
v
+y
'''

class Visualiser:
    def __init__(self, realm: Realm) -> None:
        self.realm = realm

        pygame.init()
        width, height = 640, 480
        self.screen = pygame.display.set_mode((width, height))


    def start(self) -> None:
        while True:
            self.screen.fill("white")

            self.draw_graph()

            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    pygame.quit()
                    sys.exit()

            pygame.display.update()

            # TODO: STEP the simulation by one timestep


    def draw_graph(self) -> None:
        for node in self.realm.nodes.values():
            self.draw_node(node)

        for road in self.realm.roads.values():
            self.draw_road(road)


    def draw_node(self, node: Node) -> None:
        pygame.draw.circle(self.screen, "blue", node.pos.to_tuple(), 10)
        for _ in node._trucks:
            pygame.draw.circle(self.screen, "green", node.pos.to_tuple(), 2)

    def draw_road(self, road: Road) -> None:
        pygame.draw.line(self.screen, "black", road._start.pos.to_tuple(), road._end.pos.to_tuple(), width=5)
        for truck in road._trucks:
            pygame.draw.circle(self.screen, "green", road.getPosition(truck.position).to_tuple(), 5)