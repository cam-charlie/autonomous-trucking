from __future__ import annotations
from concurrent import futures
import time
import grpc
import os
import sys

sys.path.append(os.getcwd())
from simulation.env import Env
from main import setUp, step

import trucking_pb2
import trucking_pb2_grpc

from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from typing import Any


class PositionDataStreamerServicer(trucking_pb2_grpc.PositionDataStreamerServicer):
    def __init__(self, env: Env) -> None:
        self.currTime = 0
        self.env = env


    def getPositionData(self, request: trucking_pb2.TimeDelta, context: Any) -> trucking_pb2.PositionDataStream:
        stream = []

        s = int(request.seconds)

        for curr_time in range(s * 30):
            trucks_at_time = []

            for (tid, t) in env.realm.trucks.items():
                trucks_at_time.append(trucking_pb2.Truck(truck_id=int(str(tid)[1:]), destination_id=t.destination, road_id=1, progress=t.position))

            trucksPosAtTime = trucking_pb2.TruckPositionsAtTime(trucks=trucks_at_time, time=(self.currTime + curr_time)/30)
            stream.append(trucksPosAtTime)
            step(env)
        self.currTime += s * 30
        return trucking_pb2.PositionDataStream(trucks=stream)


class ConfigurationStreamerServicer(trucking_pb2_grpc.PositionDataStreamerServicer):
    def __init__(self, pds: trucking_pb2_grpc.PositionDataStreamerServicer) -> None:
        self.pds = pds

    def startFromConfig(self, request: trucking_pb2.ConfigAsString, context: Any) -> trucking_pb2.Void:
        self.pds.currTime = 0 # restart! 
        env.reset(request.json)
        return trucking_pb2.Void() 


def serve(env: Env) -> None:
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))

    pds = PositionDataStreamerServicer(env) 

    trucking_pb2_grpc.add_PositionDataStreamerServicer_to_server(
        pds, server)

    trucking_pb2_grpc.add_ConfigurationStreamerServicer_to_server(
        ConfigurationStreamerServicer(pds), server)

    server.add_insecure_port('[::]:50051')
    server.start()
    server.wait_for_termination()


if __name__ == '__main__':
    env = setUp()

    serve(env)
