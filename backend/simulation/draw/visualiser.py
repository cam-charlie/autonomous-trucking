# pylint: skip-file

from __future__ import annotations
import pygame
import sys
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..realm.realm import Realm


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

    def refresh(self) -> None:
        self.screen.fill("white")

        self.draw_graph()

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()

        pygame.display.update()

    def draw_graph(self) -> None:
        for node in self.realm.nodes.values():
            node.draw(self.screen)

        for edge in self.realm.edges.values():
            edge.draw(self.screen)
