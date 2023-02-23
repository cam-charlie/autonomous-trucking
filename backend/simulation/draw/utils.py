from abc import ABC, abstractmethod
import pygame
from pygame import Surface

pygame.font.init()

DEFAULT_FONT = pygame.font.SysFont("arialunicode", 12)

class Drawable(ABC):
    @abstractmethod
    def draw(self, screen: Surface) -> None:
        pass