from google.protobuf.internal import containers as _containers
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from typing import ClassVar as _ClassVar, Iterable as _Iterable, Mapping as _Mapping, Optional as _Optional, Union as _Union

DESCRIPTOR: _descriptor.FileDescriptor

class PositionDataStream(_message.Message):
    __slots__ = ["trucks"]
    TRUCKS_FIELD_NUMBER: _ClassVar[int]
    trucks: _containers.RepeatedCompositeFieldContainer[TruckPositionsAtTime]
    def __init__(self, trucks: _Optional[_Iterable[_Union[TruckPositionsAtTime, _Mapping]]] = ...) -> None: ...

class TimeDelta(_message.Message):
    __slots__ = ["seconds"]
    SECONDS_FIELD_NUMBER: _ClassVar[int]
    seconds: float
    def __init__(self, seconds: _Optional[float] = ...) -> None: ...

class Truck(_message.Message):
    __slots__ = ["curr_accel", "curr_speed", "destination_id", "progress", "road_id", "truck_id"]
    CURR_ACCEL_FIELD_NUMBER: _ClassVar[int]
    CURR_SPEED_FIELD_NUMBER: _ClassVar[int]
    DESTINATION_ID_FIELD_NUMBER: _ClassVar[int]
    PROGRESS_FIELD_NUMBER: _ClassVar[int]
    ROAD_ID_FIELD_NUMBER: _ClassVar[int]
    TRUCK_ID_FIELD_NUMBER: _ClassVar[int]
    curr_accel: float
    curr_speed: float
    destination_id: int
    progress: float
    road_id: int
    truck_id: int
    def __init__(self, truck_id: _Optional[int] = ..., destination_id: _Optional[int] = ..., curr_speed: _Optional[float] = ..., curr_accel: _Optional[float] = ..., road_id: _Optional[int] = ..., progress: _Optional[float] = ...) -> None: ...

class TruckPositionsAtTime(_message.Message):
    __slots__ = ["time", "trucks"]
    TIME_FIELD_NUMBER: _ClassVar[int]
    TRUCKS_FIELD_NUMBER: _ClassVar[int]
    time: float
    trucks: _containers.RepeatedCompositeFieldContainer[Truck]
    def __init__(self, trucks: _Optional[_Iterable[_Union[Truck, _Mapping]]] = ..., time: _Optional[float] = ...) -> None: ...
