#!/bin/bash

: '
This is a template file showing a parallel network test between 2 pairs of servers

Two servers act as iPerf3 servers, while the other two act as iPerf3 clients
Curl commands are sent to the Flask agents running on each server

An arbitrary number of servers can be added by following the same pattern
'

# Start iperf3 server containers in parallel
curl -X POST "http://{server1_address}:{server1_agent_port}/iperf/server" -H "Content-Type: application/json" -d '{"name": "{container name}", "port": "{port to run container on}' &
curl -X POST "http://{server2_address}:{server2_agent_port}/iperf/server" -H "Content-Type: application/json" -d '{"name": "{container name}", "port": "{port to run container on}' &
...

wait

# Run iperf3 client containers in parallel
curl -X POST "http://{client1_address}:{client1_agent_port}/iperf/client" -H "Content-Type: application/json" -d '{"name": "{container name}", "server_address": "{server1 or server2 address}", "server_port": "{server container port}", "json_output": true, "time": "{seconds to run test}"}' &
curl -X POST "http://{client2_address}:{client2_agent_port}/iperf/client" -H "Content-Type: application/json" -d '{"name": "{container name}", "server_address": "{server2 or server1 address}", "server_port": "{server container port}", "json_output": true, "time": "{seconds to run test}"}' &
...

wait

