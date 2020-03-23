# Set base image
FROM python:3.8.2-alpine3.11

# Install packages
RUN apk add bash socat

# Install Python packages
RUN pip install dnspython

# Add sources
COPY bootstrap.sh /bootstrap.sh
COPY handle_connection.sh /handle_connection.sh
COPY lookup_ecs_service.py /lookup_ecs_service.py

# Override default entry point
CMD /bootstrap.sh