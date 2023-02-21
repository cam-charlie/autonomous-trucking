from __future__ import annotations
from abc import ABC
from ..lib import id as ID

from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from typing import Optional

class Entity(ABC):
    
    def __init__(self, id: Optional[int] = None) -> None:
        if id is None:
            self._id = ID.generateID()
        else:
            self._id = id
            ID.registerID(id)

    @property
    def id(self) -> int:
        """Unique identifier

        Can be either defined or generated
        """
        return self._id

class Actor(Entity, ABC):

    def act(self, action: Optional[float], dt: float) -> None:
        raise NotImplementedError
    