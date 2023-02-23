from __future__ import annotations
from concurrent import futures
import time
import grpc
import os
import sys

sys.path.append(os.getcwd())
from simulation.env import Env

import trucking_pb2
import trucking_pb2_grpc

from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from typing import Any


class PositionDataStreamerServicer(trucking_pb2_grpc.PositionDataStreamerServicer):
    def __init__(self) -> None:
        self.currTime = 0

    def getPositionData(self, request: trucking_pb2.TimeDelta, context: Any) -> trucking_pb2.PositionDataStream:
        stream = []

        s = int(request.seconds)

        for curr_time in range(s * 30):
            trucks_at_time = []

            for (tid, t) in env.realm.trucks.items():
                trucks_at_time.append(trucking_pb2.Truck(truck_id=tid, destination_id=t.destination, road_id=1, progress=t.position))

            trucksPosAtTime = trucking_pb2.TruckPositionsAtTime(trucks=trucks_at_time, time=(self.currTime + curr_time)/30)
            stream.append(trucksPosAtTime)
            env.step({})
        self.currTime += s * 30
        return trucking_pb2.PositionDataStream(trucks=stream)


def serve() -> None:
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    trucking_pb2_grpc.add_PositionDataStreamerServicer_to_server(
        PositionDataStreamerServicer(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    server.wait_for_termination()


if __name__ == '__main__':
    print("Usage: main.py \"path-to-config-json\"")
    env = Env()
    env.reset(sys.argv[1])

    serve()
