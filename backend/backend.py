import os
import json
from pprint import pprint
from bottle import hook, request, response, route, run, get, post, put
import geomongo

@hook('after_request')
def enable_cors():
    response.content_type = "application/json"
    response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE'
    response.headers['Access-Control-Allow-Headers'] = 'origin, accept, Content-Type,\
                                                         X-Requested-With, X-CSRF-Token'
    response['Access-Control-Max-Age'] = '180'
    response.headers['Access-Control-Allow-Origin'] = '*'


@route('/ads', method=['GET', 'HEAD', 'OPTIONS'])
def get_ads():
    if request.method == "OPTIONS":
        return ""

    dbrequest = {}
    dbrequest['lat'] = float(request.query.get('lat'))
    dbrequest['lng'] = float(request.query.get('lng'))
    dbrequest['radius'] = int(float(request.query.get('radius')))
    dbrequest['categories'] = request.query.get('categories').split(',')
    dbrequest['q'] = request.query.get('q')
    pprint(dbrequest)
    dbanswer = geomongo.get_ads(**dbrequest)
    return json.dumps(dbanswer)


@post('/ads')
def post_ad():
    if request.method == "OPTIONS":
        return ""

    dbrequest = json.loads(request.params.keys()[0])
    del dbrequest['id']
    dbanswer = geomongo.post_ad(**dbrequest)
    return json.dumps(dbanswer)


@get('/ads/:id')
def get_ad(id):
    return id

@route('/bar')
def say_bar():
    return {'type': 'friendly', 'content': 'Hi!'}

run(host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
