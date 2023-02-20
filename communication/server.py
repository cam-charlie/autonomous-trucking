from concurrent import futures

import time

import grpc
import trucking_pb2
import trucking_pb2_grpc

class PositionDataStreamerServicer(trucking_pb2_grpc.PositionDataStreamerServicer):
    def __init__(self): 
        self.currTime = 0

    def getPositionData(self, request, context): 
        time.sleep(2)
        s = request.seconds
        stream = []
        for i in range(int(s) * 10):
            t = trucking_pb2.Truck(truck_id=1, destination_id=1, road_id=1, progress = (round(self.currTime * 10) % 100)/100)
            trucksPosAtTime = trucking_pb2.TruckPositionsAtTime(trucks=[t], time=float(self.currTime))
            stream.append(trucksPosAtTime)
            self.currTime += 0.1
        return trucking_pb2.PositionDataStream(trucks=stream)




def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    trucking_pb2_grpc.add_PositionDataStreamerServicer_to_server(
        PositionDataStreamerServicer(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    server.wait_for_termination()


if __name__ == '__main__':
    serve()
