#!/bin/bash 

for i in *.proto; do 
    [ -f "$i" ] || break 
    protoc -I. --dart_out=grpc:. \
        ./"$i"
    python3 -m grpc_tools.protoc \
        -I. \
        --python_out=. \
        --pyi_out=. \
        --grpc_python_out=. "$i"
done
