from flask import Flask, render_template, request
import socket
import json

app = Flask(__name__)

@app.route("/", methods=['GET', 'POST'])
def return_status():
    with open('probe-state.json', 'r') as probe_state_file:
        probe_state = json.load(probe_state_file)
    probe_state_file.close()

    with open('version.json', 'r') as version_file:
        version = json.load(version_file)
    version_file.close()

    if request.method == 'POST':
        if 'livez' in request.form:
            if probe_state["livez"] == 'Healthy':
                probe_state["livez"] = 'Unhealthy'
                with open("probe-state.json", "w") as probe_state_file:
                    json.dump(probe_state, probe_state_file)
                probe_state_file.close()       
                return "Set Liveness Probe to Unhealthy"    
            else:
                probe_state["livez"] = 'Healthy'
                with open("probe-state.json", "w") as probe_state_file:
                    json.dump(probe_state, probe_state_file)
                probe_state_file.close()
                return "Set Liveness Probe to Healthy"
        if 'readyz' in request.form:
            if probe_state["readyz"] == 'Healthy':
                probe_state["readyz"] = 'Unhealthy'
                with open("probe-state.json", "w") as probe_state_file:
                    json.dump(probe_state, probe_state_file)
                probe_state_file.close()
                return "Set Readiness Probe to Unhealthy"
            else:
                probe_state["readyz"] = 'Healthy'
                with open("probe-state.json", "w") as probe_state_file:
                    json.dump(probe_state, probe_state_file)
                probe_state_file.close()
                return "Set Readiness Probe to Healthy"
    elif request.method == 'GET':
        return render_template('index.html', from_hostname=socket.gethostname(), readyz=probe_state["readyz"], livez=probe_state["livez"], version=version["version"])

@app.route("/livez")
def return_livez():
    with open('probe-state.json', 'r') as probe_state_file:
        probe_state = json.load(probe_state_file)
    probe_state_file.close() 
    if probe_state["livez"] == 'Healthy':
        return {
            "status": 200,
            "title": "OK"
        }, 200
    else:
        return {
            "status": 500,
            "title": "Unhealthy"
        }, 500

@app.route("/readyz")
def return_readyz():
    with open('probe-state.json', 'r') as probe_state_file:
        probe_state = json.load(probe_state_file)
    probe_state_file.close() 
    if probe_state["readyz"] == 'Healthy':    
        return {
            "status": 200,
            "title": "OK"
        }, 200
    else:
        return {
            "status": 500,
            "title": "Unhealthy"
        }, 500

if __name__ == "__main__":
    app.run(host='0.0.0.0')