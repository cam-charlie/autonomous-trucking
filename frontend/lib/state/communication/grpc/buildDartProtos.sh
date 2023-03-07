#!/bin/bash 

for i in ../../../../../protos/*.proto; do 
    [ -f "$i" ] || break 
    protoc -I. \
        --proto_path=../../../../../protos \
        --dart_out=grpc:. \
        ./"$i"
done


