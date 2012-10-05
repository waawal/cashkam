
import sys
import os
import json
from pprint import pprint


from gevent import monkey; monkey.patch_all()

from bottle import Bottle, hook, request, response, route, run, get, post, put

import geomongo

app = Bottle()

### CORS Implementation

@app.hook('after_request')
def enable_cors():
    """ Appends CORS-related data to response headers """
    headers = 'origin, accept, Content-Type, X-Requested-With, X-CSRF-Token'
    response.content_type = "application/json"
    response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE'
    response.headers['Access-Control-Allow-Headers'] = headers
    response['Access-Control-Max-Age'] = '180'
    response.headers['Access-Control-Allow-Origin'] = '*'

@app.route('/ads', method=['OPTIONS', 'GET'])
def get_ads():
    if request.method == 'OPTIONS':
        return {}
    else:
        dbrequest = {}
        dbrequest['swlat'] = float(request.query.get('swlat'))
        dbrequest['swlng'] = float(request.query.get('swlng'))
        dbrequest['nelat'] = float(request.query.get('nelat'))
        dbrequest['nelng'] = float(request.query.get('nelng'))
        #dbrequest['radius'] = int(float(request.query.get('radius')))
        dbrequest['categories'] = request.query.get('categories').split(',')
        dbrequest['q'] = request.query.get('q')
        pprint(dbrequest)
        dbanswer = geomongo.get_ads(**dbrequest)
        return json.dumps(dbanswer)

@app.route('/ads', method=['POST'])
def post_ad():
    dbrequest = json.loads(request.params.keys()[0])
    del dbrequest['id']
    dbanswer = geomongo.post_ad(**dbrequest)
    return json.dumps(dbanswer)

@app.route('/ads/:id', method=['GET'])
def get_ad(id):
    return id


#run(app, host='0.0.0.0', port=int(sys.argv[1]), server='gevent')
