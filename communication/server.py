from concurrent import futures

import time

import grpc
import trucking_pb2
import trucking_pb2_grpc

#class MessagePasserServicer(example_pb2_grpc.MessagePasserServicer):
#    def GetMsg(self, request, context):
#        return example_pb2.Msg(text="hello")
#
#class UpCounterServicer(example_pb2_grpc.UpCounterServicer):
#    def __init__(self):
#        self.x = 0
#
#    def CountUP(self, request, context):
#        self.x += 1
#        return example_pb2.Void()
#
#    def GetCounter(self, request, context):
#        return example_pb2.Counter(count=self.x)

class PositionDataStreamerServicer(trucking_pb2_grpc.PositionDataStreamerServicer):
    def __init__(self): 
        self.currTime = 0

    def getPositionData(self, request, context): 
        time.sleep(2)
        s = request.seconds
        stream = []
        for i in range(int(s) * 10):
            #p = trucking_pb2.Position(road_id=1, progress=(float((round(self.currTime)) % 100)))
            t = trucking_pb2.Truck(truck_id=1, destination_id=1, road_id=1, progress = round(self.currTime * 10) % 100) #progress=(float((round(self.currTime + (self.currTime // 100) * 1000)) % 100)))
            trucksPosAtTime = trucking_pb2.TruckPositionsAtTime(trucks=[t], time=float(self.currTime))
            stream.append(trucksPosAtTime)
            self.currTime += 0.1
        return trucking_pb2.PositionDataStream(trucks=stream)




#def serve():
#    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
#    example_pb2_grpc.add_UpCounterServicer_to_server(
#        UpCounterServicer(), server)
#    example_pb2_grpc.add_MessagePasserServicer_to_server(
#        MessagePasserServicer(), server)
#    server.add_insecure_port('[::]:50051')
#    server.start()
#    server.wait_for_termination()

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    trucking_pb2_grpc.add_PositionDataStreamerServicer_to_server(
        PositionDataStreamerServicer(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    server.wait_for_termination()
if __name__ == '__main__':
    serve()
