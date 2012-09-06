import os
import json
from pprint import pprint
from bottle import hook, request, response, route, run, get, post, put
import geomongo

@hook('after_request')
def enable_cors():
    response.content_type = "application/json"
    response.headers['Access-Control-Allow-Methods'] = 'GET,POST,PUT,DELETE'
    response.headers['Access-Control-Allow-Headers'] = 'Origin,Accept,Content-Type,X-Requested-With,X-CSRF-Token'
    response.headers['Access-Control-Allow-Origin'] = '*'


@route('/ads', method=['GET', 'HEAD', 'OPTIONS'])
def get_ads():
    if request.method == "OPTIONS":
        return
    #test = [{'media':'cat.jpg', 'text': 'im a cat', 'id': '34dfg3'},
    #        {'media':'dog.jpg', 'text': 'im a dog', 'id': '3ddfg3'},
    #        {'media':'bird.jpg', 'text': 'im a bird', 'id': '34d4g3'},
    #        {'media':'car.jpg', 'text': 'im a car', 'id': '34dfg6'}]
    #nelng = float(request.query.get('neLng'))
    #nelat = float(request.query.get('neLat'))
    #swlng = float(request.query.get('swLng'))
    #swlat = float(request.query.get('swLat'))
    lat = float(request.query.get('lat'))
    lng = float(request.query.get('lng'))
    radius = int(request.query.get('radius'))
    categories = request.query.get('categories').split(',')
    q = request.query.get('q')
    
    dbanswer = geomongo.get_ads(lat, lng, nelat, nelng, swlat, swlng, categories)
    result = []
    for rec in dbanswer:
    #    pprint(rec)
        result.append({'id': str(rec['_id']), 'media': rec['media'], 'text': rec['text']})
#    pprint([item for item in request.query.items()])
    return json.dumps(result)#(test)

@get('/ads/:id')
def get_ad(id):
    return id

@route('/bar')
def say_bar():
    return {'type': 'friendly', 'content': 'Hi!'}

run(host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
