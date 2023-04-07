#!/bin/bash

exec sudo podman run \
    --rm \
    -it \
    --privileged \
    --security-opt label=disable \
    -v "$PWD:$PWD" \
    -w "$PWD" \
    isogenerator:builder \
    "$PWD/isopatch.sh" "$@"
