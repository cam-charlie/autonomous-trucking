#!/bin/bash 

for i in ../protos/*.proto; do 
    [ -f "$i" ] || break 
    python3 -m grpc_tools.protoc \
        -I. \
        --python_out=. \
        --mypy_out=grpc:. \
        --pyi_out=grpc:. \
        --grpc_python_out=. \
        --mypy_grpc_out=grpc:. "$i"
done


