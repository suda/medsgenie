import os
from datetime import timedelta
from functools import update_wrapper
from flask import Flask, send_from_directory, render_template, jsonify, make_response, request, current_app
import requests

# the all-important app variable:
app = Flask(__name__, template_folder='')
base_url = "https://api.particle.io/v1/devices/%s" % os.environ['DEVICE_NAME']
access_token = os.environ['ACCESS_TOKEN']

def crossdomain(origin=None, methods=None, headers=None,
                max_age=21600, attach_to_all=True,
                automatic_options=True):
    if methods is not None:
        methods = ', '.join(sorted(x.upper() for x in methods))
    if headers is not None and not isinstance(headers, basestring):
        headers = ', '.join(x.upper() for x in headers)
    if not isinstance(origin, basestring):
        origin = ', '.join(origin)
    if isinstance(max_age, timedelta):
        max_age = max_age.total_seconds()

    def get_methods():
        if methods is not None:
            return methods

        options_resp = current_app.make_default_options_response()
        return options_resp.headers['allow']

    def decorator(f):
        def wrapped_function(*args, **kwargs):
            if automatic_options and request.method == 'OPTIONS':
                resp = current_app.make_default_options_response()
            else:
                resp = make_response(f(*args, **kwargs))
            if not attach_to_all and request.method != 'OPTIONS':
                return resp

            h = resp.headers

            h['Access-Control-Allow-Origin'] = origin
            h['Access-Control-Allow-Methods'] = get_methods()
            h['Access-Control-Max-Age'] = str(max_age)
            if headers is not None:
                h['Access-Control-Allow-Headers'] = headers
            return resp

        f.provide_automatic_options = False
        return update_wrapper(wrapped_function, f)
    return decorator

@app.route("/alive")
def alive():
    response = requests.get("%s?access_token=%s" % (base_url, access_token))
    print('DEBUG', response.text)
    return jsonify({
        'alive': response.json()['connected']
    })

@app.route("/serve")
def serve():
    response = requests.post("%s/serve" % base_url, data={
        'access_token': access_token,
        'arg': request.args.get('index')
    })
    print('DEBUG', response.text)
    return jsonify(response.json())

@app.route('/')
@crossdomain(origin='*')
def root():
    return render_template('index.html')

@app.route('/static/<path:path>')
def send_static(path):
    return send_from_directory('static', path)

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True, port=80)
