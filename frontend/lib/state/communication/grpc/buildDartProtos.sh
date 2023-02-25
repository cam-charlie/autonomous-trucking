#!/bin/bash 

for i in ../protos/*.proto; do 
    [ -f "$i" ] || break 
    protoc -I. --dart_out=grpc:. \
        ./"$i"
done


