#!/bin/bash

# Use socat to listen on a port, and forward new connections to a handler script
echo "Setting up socat to listen on ${LISTENER_PORT}"
socat TCP-LISTEN:${LISTENER_PORT},fork,su=nobody EXEC:/handle_connection.sh