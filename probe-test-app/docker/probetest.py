from flask import Flask, render_template, session, request
import socket
from flask_session import Session
from cachelib.file import FileSystemCache

app = Flask(__name__)
app.secret_key = 'BAD_SECRET_KEY'

@app.route("/", methods=['GET', 'POST'])
def return_status():
    if request.method == 'POST':
        if 'livez' in request.form:
            if session.get('livez', 'Healthy') == 'Healthy':
                session['livez'] = 'Unhealthy'
                return "Set Liveness Probe to Unhealthy"
            else:
                session['livez'] = 'Healthy'
                return "Set Liveness Probe to Healthy"
        if 'readyz' in request.form:
            if session.get('readyz', 'Healthy') == 'Healthy':
                session['readyz'] = 'Unhealthy'
                return "Set Readiness Probe to Unhealthy"
            else:
                session['readyz'] = 'Healthy'
                return "Set Readiness Probe to Healthy"
    elif request.method == 'GET':
        return render_template('index.html', from_hostname=socket.gethostname(), readyz=session.get('readyz', 'Healthy'), livez=session.get('livez', 'Healthy'))

@app.route("/livez")
def return_livez():
    if session.get('livez', 'Healthy') == 'Healthy':
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
    if session.get('readyz', 'Healthy') == 'Healthy':    
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
    app.config['SESSION_TYPE'] = 'cachelib'
    app.config['SESSION_SERIALIZATION_FORMAT'] = 'json'
    app.config['SESSION_CACHELIB'] = FileSystemCache(cache_dir='flask_session')
    Session(app)