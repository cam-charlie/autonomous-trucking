from __future__ import annotations
from abc import ABC
from ..lib import id as ID

from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from typing import Optional, List

class Entity(ABC):

    def __init__(self, id_: Optional[int] = None) -> None:
        if id_ is None:
            self._id = ID.generateID()
        else:
            self._id = id_
            ID.registerID(id_)

    @property
    def id_(self) -> int:
        """Unique identifier
        Can be either defined or generated
        """
        return self._id

class Actor(Entity, ABC):

    def __init__(self, id_: Optional[int]):
        super().__init__(id_)
        self._accumulated_reward: float = 0
        self._accumulated_info: List[str] = []

    def act(self, action: Optional[float], dt: float) -> None:
        raise NotImplementedError

    def get_accumulated_reward(self) -> float:
        """ Returns accumulated reward and resets to 0
        """
        res = self._accumulated_reward
        self._accumulated_reward = 0
        return res

    def get_accumulated_info(self) -> List[str]:
        res = self._accumulated_info
        self._accumulated_info = []
        return res
