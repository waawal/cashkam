

import os

from gevent import monkey, spawn, queue; monkey.patch_all()

import redis
from bottle import hook, request, response, route, run, get

connections = []

# Setting up the connection to Redis
pool = redis.ConnectionPool(host='localhost', port=6379, db=0)
r = redis.Redis(connection_pool=pool)
pubsub = r.pubsub()
pubsub.subscribe('eventstream')
# # # # # # # # # # # # # # # # # # #

def sender_service():
    for message in pubsub.listen():
        if message['type'] == 'message':
            data = message['data']
            user, msg = data.split(':')[0]
            print user
            [connection['body'].put("data: "+msg+"\n\n")
             for connection in connections if connection['user'] == user]

def subscription(body, channel):
    connection = {'user': channel or 'all',
                  'body': body
                  }
    connections.append(connection)

@get('/subscribe/<channel>')
def register(channel):
    response.content_type = 'text/event-stream'
    response.headers['Access-Control-Allow-Origin'] = '*'

    print request.query.items()
    body = queue.Queue()
    spawn(subscription, body, channel)
    return body

@get('/')
def index():
    return """<article id="log"></article>

  <script>
    var source = new EventSource('/subscribe/yoyo');

    source.addEventListener('message', function (event) {
      alert(event.data);
    }, false);
  </script>"""

spawn(sender_service)
run(host='0.0.0.0', port=int(os.environ.get("PORT", 2222)), server='gevent')

