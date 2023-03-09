# pylint: skip-file

from __future__ import annotations
import pygame
import sys
from typing import TYPE_CHECKING
from .utils import COMIC_SANS
from simulation.config import Config

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
        width, height = 2*640, 2*480
        self.screen = pygame.display.set_mode((width, height))

    def refresh(self) -> None:
        self.screen.fill("white")

        self.draw_graph()
        self.draw_params()

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

    def draw_params(self) -> None:
        text_surface = COMIC_SANS.render(str(round(Config.get_instance().SIM_TIME, 2)), False, (0, 0, 0))
        #rect = pygame.Rect(100, 100, 120, 120)
        #text_rect = text_surface.get_rect(center=rect.center)
        text_rect = text_surface.get_rect(center=(50,50))
        self.screen.blit(text_surface, text_rect)
