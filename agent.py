from flask import Flask, request, jsonify
import subprocess
import json
import requests
import socket

app = Flask(__name__)

@app.route('/iperf_container', methods=['POST'])
def iperf_container():
    data = request.json
    name = data.get('name')
    port = str(data.get('port'))
    iperf3_options = data.get('iperf3_options')
    try:
        proc = subprocess.run(["podman", "run", "-it", "--rm", "--name", name, "-p", port+":"+port, "networkstatic/iperf3", iperf3_options], stdout=subprocess.PIPE)
        for line in proc.stdout.decode().split("\n"):
            print(line)
        return jsonify({'status': 'success'}), 201
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 400
    

@app.route('/iperf/server', methods=['POST'])
def iperf_server():
    data = request.json
    name = data.get('name')
    port = str(data.get('port'))
    iperf3_options = data.get('iperf3_options')
    host = socket.gethostname()

    try:
        if iperf3_options == True:  
            proc = subprocess.run(["podman", "run", "-itd", "--rm", "--name", name, "--network=host", 
                                "networkstatic/iperf3", "-4", "-s", "-p", port, iperf3_options], stdout=subprocess.PIPE)
        else:
            proc = subprocess.run(["podman", "run", "-itd", "--rm", "--name", name, "--network=host", 
                                "networkstatic/iperf3", "-4", "-s", "-p", port], stdout=subprocess.PIPE)
            
        return f"iPerf3 container succesfully deployed on {host}\n", 201
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 400

@app.route('/iperf/delete', methods=['POST'])
def iperf_delete():
    data = request.json
    name = data.get('name')
    host = socket.gethostname()

    try:
        proc = subprocess.run(["podman", "container", "stop", name], stdout=subprocess.PIPE)

        #return jsonify({'status': 'success'}), 201
        return f"Container succesfully removed on {host}\n", 201

    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 400

@app.route('/iperf/client', methods=['POST'])
def iperf_client():
    data = request.json
    name = data.get('name')
    time = data.get('time')
    server_hostname = data.get('server_hostname')
    server_port = str(data.get('server_port'))
    json_output = data.get('json_output')

    try:
        if json_output == True:
            proc = subprocess.run(["podman", "run", "-it", "--rm", "--name", name, "--network=host", 
                                "networkstatic/iperf3", "-4", "-J", "-c", server_hostname, 
                                "-p", server_port, "-P", "16", "-t", time], stdout=subprocess.PIPE)

            with open("Results/"+ server_hostname + "_" + socket.gethostname() + ".json", "w") as f:
                f.write(proc.stdout.decode())

        else:
            proc = subprocess.run(["podman", "run", "-it", "--rm", "--name", name, "--network=host", 
                                "networkstatic/iperf3", "-4", "-c", server_hostname, 
                                "-p", server_port, "-P", "16", "-t", time], stdout=subprocess.PIPE)

            with open("Results/"+ server_hostname + "_" + socket.gethostname() + ".txt", "w") as f:
                f.write(proc.stdout.decode())

        return jsonify({'status': 'success'}), 201
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 400
    
@app.route('/receiver', methods=["GET", "POST"])
def receiver():
    data = request.get_json()
    filename = data.get('output_name')
    with open(filename+".json", "w") as f:
        json.dump(data, f, indent=2)
    return jsonify({"status": "ok", "received_keys": list(data.keys())})

@app.route('/send_json', methods=['POST'])
def send_json():
    data = request.json
    server_name = data.get('server_name', 'localhost')  # Default to localhost if not provided
    filename = data.get('filename')
    url = f"http://{server_name}:15011/receiver"

    # Load JSON file to send
    with open(filename) as f:
        payload = json.load(f)
    payload['output_name'] = server_name + "_" + socket.gethostname()

    try:
        resp = requests.post(url, json=payload, timeout=10)
        return jsonify(resp.json()), resp.status_code
    
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500

if __name__ == '__main__':  
    app.run(host='0.0.0.0', port=15011)


