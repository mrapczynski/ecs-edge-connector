#!/bin/bash

# Lookup destination address and port from DNS
TARGET=`python /lookup_ecs_service.py`

# Pass connection through to target
socat - TCP:${TARGET}