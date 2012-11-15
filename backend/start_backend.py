
import sys
import os
import json


from gevent import monkey; monkey.patch_all()

from bottle import Bottle, hook, request, response, route, run, get, post, put, abort, error

import geomongo

app = Bottle()

import itsdangerous
s = URLSafeSerializer('secret-key')
#s = itsdangerous.TimestampSigner('secret-key') # should check env
MAX_AGE = 60 * 60 * 48 // Two days

def check_auth(auth, max_age=MAX_AGE):
    try:
        return s.loads(auth)
        #decoded_payload = s.unsign(auth, max_age=max_age)
    #except BadSignature, e:
    except:
        return False

### CORS Implementation

@app.hook('after_request')
def enable_cors():
    """ Appends CORS-related data to response headers """

    headers = 'origin, accept, host, Content-Type, X-Requested-With, X-CSRF-Token'

    response.content_type = "application/json"
    response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = headers
    response['Access-Control-Max-Age'] = '86400'
    response['Access-Control-Allow-Credentials'] = 'true'
    response.headers['Access-Control-Allow-Origin'] = request.get_header('Origin', default="*")



@app.route('/ads', method=['OPTIONS', 'GET'])
def get_ads():
    if request.method == 'OPTIONS':
        return {}
    else:
        latlng = (float(request.query.get('lat')), float(request.query.get('lng')))
        index = int(request.query.get('i', False))
        dbanswer = geomongo.get_ads(latlng, index)
        return json.dumps(dbanswer)

@app.route('/ads', method=['POST'])
def post_ad():
    dbrequest = json.loads(request.params.keys()[0])
    if 'id' in dbrequest:
        del dbrequest['id']
    dbanswer = geomongo.post_ad(**dbrequest)
    return json.dumps(dbanswer)

@app.route('/ads/:id', method=['GET'])
def get_ad(id):
    return id

@app.route('/users', method=['GET', 'OPTIONS'])
def get_users():
    if request.method == 'OPTIONS':
        return {}


    auth = request.get_cookie('auth')
    if auth:
        user = check_auth(auth)
        if user:
            return json.dumps([{'name': user, 'likes': [], 'ads': []}])
        else:
            response.delete_cookie('auth')
            response.status = "403 Login Failed"
            return json.dumps({'message': "Login Failed"})


    email = request.query.get('email')
    password = request.query.get('password')
    print email, password
    if email == "a@a.a" and password == "pass":
        response.set_cookie('auth',  s.dumps(email), path="/")
        return json.dumps([{'name': 'daniel', 'likes': [], 'ads': []}])
    else:
        response.status = "403 Login Failed"
        return json.dumps({'message': "Login Failed"})

@app.route('/users', method=['POST'])
def post_users():
    pass

#run(app, host='0.0.0.0', port=int(sys.argv[1]), server='gevent')
