#!/bin/bash
# sense2->dtn01
# sense3->dtn02
# sense4->dtn03
# sense5->dtn04

# Start iperf3 servers in parallel on FNAL servers
curl -X POST "http://cmssense2.fnal.gov:15011/iperf/server" -H "Content-Type: application/json" -d '{"name": "iperf_server", "port": "15015"}' &
curl -X POST "http://cmssense2.fnal.gov:15011/iperf/server" -H "Content-Type: application/json" -d '{"name": "iperf_server2", "port": "15016"}' &
curl -X POST "http://cmssense3.fnal.gov:15011/iperf/server" -H "Content-Type: application/json" -d '{"name": "iperf_server", "port": "15015"}' &
curl -X POST "http://cmssense3.fnal.gov:15011/iperf/server" -H "Content-Type: application/json" -d '{"name": "iperf_server2", "port": "15016"}' &
curl -X POST "http://cmssense4.fnal.gov:15011/iperf/server" -H "Content-Type: application/json" -d '{"name": "iperf_server", "port": "15015"}' &
curl -X POST "http://cmssense4.fnal.gov:15011/iperf/server" -H "Content-Type: application/json" -d '{"name": "iperf_server2", "port": "15016"}' &
curl -X POST "http://cmssense5.fnal.gov:15011/iperf/server" -H "Content-Type: application/json" -d '{"name": "iperf_server", "port": "15015"}' &
curl -X POST "http://cmssense5.fnal.gov:15011/iperf/server" -H "Content-Type: application/json" -d '{"name": "iperf_server2", "port": "15016"}'

wait

# Run clients in parallel on dtn01 and dtn04
curl -X POST "http://cmsdtn01.hep.wisc.edu:15011/iperf/client" -H "Content-Type: application/json" -d '{"name": "iperf_client", "server_hostname": "cmssense2.fnal.gov", "server_port": "15015", "json_output": true}' &
curl -X POST "http://cmsdtn02.hep.wisc.edu:15011/iperf/client" -H "Content-Type: application/json" -d '{"name": "iperf_client", "server_hostname": "cmssense2.fnal.gov", "server_port": "15016", "json_output": true}' &
curl -X POST "http://cmsdtn03.hep.wisc.edu:15011/iperf/client" -H "Content-Type: application/json" -d '{"name": "iperf_client", "server_hostname": "cmssense3.fnal.gov", "server_port": "15015", "json_output": true}' &
curl -X POST "http://cmsdtn04.hep.wisc.edu:15011/iperf/client" -H "Content-Type: application/json" -d '{"name": "iperf_client", "server_hostname": "cmssense3.fnal.gov", "server_port": "15016", "json_output": true}' &
curl -X POST "http://cmsdtn05.hep.wisc.edu:15011/iperf/client" -H "Content-Type: application/json" -d '{"name": "iperf_client", "server_hostname": "cmssense4.fnal.gov", "server_port": "15015", "json_output": true}' &
curl -X POST "http://cmsdtn06.hep.wisc.edu:15011/iperf/client" -H "Content-Type: application/json" -d '{"name": "iperf_client", "server_hostname": "cmssense4.fnal.gov", "server_port": "15016", "json_output": true}' &
curl -X POST "http://cmsdtn07.hep.wisc.edu:15011/iperf/client" -H "Content-Type: application/json" -d '{"name": "iperf_client", "server_hostname": "cmssense5.fnal.gov", "server_port": "15015", "json_output": true}' &
curl -X POST "http://cmsdtn08.hep.wisc.edu:15011/iperf/client" -H "Content-Type: application/json" -d '{"name": "iperf_client", "server_hostname": "cmssense5.fnal.gov", "server_port": "15016", "json_output": true}'

wait

# Remove the iperf3 server containers running on the FNAL servers
# Note: client containers are automatically removed after test completion
curl -X POST "http://cmssense2.fnal.gov:15011/iperf/delete" -H "Content-Type: application/json" -d '{"name": "iperf_server"}'
curl -X POST "http://cmssense2.fnal.gov:15011/iperf/delete" -H "Content-Type: application/json" -d '{"name": "iperf_server2"}'
curl -X POST "http://cmssense3.fnal.gov:15011/iperf/delete" -H "Content-Type: application/json" -d '{"name": "iperf_server"}'
curl -X POST "http://cmssense3.fnal.gov:15011/iperf/delete" -H "Content-Type: application/json" -d '{"name": "iperf_server2"}'
curl -X POST "http://cmssense4.fnal.gov:15011/iperf/delete" -H "Content-Type: application/json" -d '{"name": "iperf_server"}'
curl -X POST "http://cmssense4.fnal.gov:15011/iperf/delete" -H "Content-Type: application/json" -d '{"name": "iperf_server2"}'
curl -X POST "http://cmssense5.fnal.gov:15011/iperf/delete" -H "Content-Type: application/json" -d '{"name": "iperf_server"}'
curl -X POST "http://cmssense5.fnal.gov:15011/iperf/delete" -H "Content-Type: application/json" -d '{"name": "iperf_server2"}'


