import dns.resolver
import os
import random

# Unpack config from environment variables
ecs_target = os.getenv('ECS_SERVICE_DISCOVERY_TARGET')
ecs_target_mode = os.getenv('ECS_SERVICE_DISCOVERY_TYPE', 'SRV')
target_port = os.getenv('TARGET_PORT')

# Validate config
if ecs_target is None:
    print('Required environment variable ECS_SERVICE_DISCOVERY_TARGET is missing')
    exit(1)

# Query DNS
answers = dns.resolver.query(ecs_target, ecs_target_mode)

# Validate
if len(answers) < 1:
    print(f'DNS query on {ecs_target} returned zero {ecs_target_mode} records')
    exit(1)

# Randomly select a record
random_index = random.randrange(0, len(answers), 1)
random_answer = answers[random_index]

# Handle answer according to query type
if ecs_target_mode == 'A':
    # Since A records do not specify a port, use one provided externall
    # via the TARGET_PORT env variable
    print(f'${random_answer.address}:${target_port}', end='')

elif ecs_target_mode == 'SRV':
    # SRV records need a second level of resolution to get an address
    srv_answers = dns.resolver.query(str(random_answer.target), 'A')

    # Provide both resolved address and service port from SRV record
    print(f'{srv_answers[0].address}:{random_answer.port}', end='')