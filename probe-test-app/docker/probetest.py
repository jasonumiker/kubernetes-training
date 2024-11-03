from flask import Flask, render_template, request
import socket
import json

app = Flask(__name__)

@app.route("/", methods=['GET', 'POST'])
def return_status():
    with open('probe-state.json', 'r') as file:
        data = json.load(file)
    file.close()    
    if request.method == 'POST':
        if 'livez' in request.form:
            if data["livez"] == 'Healthy':
                data["livez"] = 'Unhealthy'
                with open("probe-state.json", "w") as file:
                    json.dump(data, file)
                file.close()       
                return "Set Liveness Probe to Unhealthy"    
            else:
                data["livez"] = 'Healthy'
                with open("probe-state.json", "w") as file:
                    json.dump(data, file)
                file.close()
                return "Set Liveness Probe to Healthy"
        if 'readyz' in request.form:
            if data["readyz"] == 'Healthy':
                data["readyz"] = 'Unhealthy'
                with open("probe-state.json", "w") as file:
                    json.dump(data, file)
                file.close()
                return "Set Readiness Probe to Unhealthy"
            else:
                data["readyz"] = 'Healthy'
                with open("probe-state.json", "w") as file:
                    json.dump(data, file)
                file.close()
                return "Set Readiness Probe to Healthy"
    elif request.method == 'GET':
        return render_template('index.html', from_hostname=socket.gethostname(), readyz=data["readyz"], livez=data["livez"])

@app.route("/livez")
def return_livez():
    with open('probe-state.json', 'r') as file:
        data = json.load(file)
    file.close() 
    if data["livez"] == 'Healthy':
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
    with open('probe-state.json', 'r') as file:
        data = json.load(file)
    file.close() 
    if data["readyz"] == 'Healthy':    
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