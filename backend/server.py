from concurrent import futures
import time
import grpc
import os
import sys

import server

sys.path.append(os.getcwd())
from simulation.env import Env
from simulation.draw.visualiser import Visualiser

import trucking_pb2
import trucking_pb2_grpc

class PositionDataStreamerServicer(trucking_pb2_grpc.PositionDataStreamerServicer):
    def __init__(self):
        self.currTime = 0

    def getPositionData(self, request, context) -> trucking_pb2.PositionDataStream:
        stream = []

        # s = int(request.seconds)
        s = 3

        for curr_time in range(s * 30):
            trucks_at_time = []
            for (tid, t) in env.realm.trucks.items():
                #route = t.route()
                trucks_at_time.append(trucking_pb2.Truck(truck_id=1, destination_id=2, road_id=1, progress=t.position))
            trucksPosAtTime = trucking_pb2.TruckPositionsAtTime(trucks=trucks_at_time, time=(self.currTime + curr_time)/30)
            stream.append(trucksPosAtTime)
            env.step({})
        self.currTime += s * 30
        return trucking_pb2.PositionDataStream(trucks=stream)





        #time.sleep(2)
        #s = request.seconds
        #stream = []
        #for i in range(int(s) * 10):
        #    t = trucking_pb2.Truck(truck_id=1, destination_id=1, road_id=1,
        #                           progress=(round(self.currTime * 10) % 100) / 100)
        #    trucksPosAtTime = trucking_pb2.TruckPositionsAtTime(trucks=[t], time=float(self.currTime))
        #    stream.append(trucksPosAtTime)
        #    self.currTime += 0.1
        #return trucking_pb2.PositionDataStream(trucks=stream)




def serve():
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



