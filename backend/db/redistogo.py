# https://github.com/andymccurdy/redis-py/pull/199
from gevent import monkey; monkey.patch_all()
import redis

#redis_url = os.getenv('REDISTOGO_URL', 'redis://localhost')

#redis_url = "redis://waawal:be8613e56cc436c5ba502a7ddb8ddb5c@clingfish.redistogo.com:9643/"
#r = redis.from_url(redis_url)

pool = redis.ConnectionPool(port=9643,
                            host='clingfish.redistogo.com',
                            password='be8613e56cc436c5ba502a7ddb8ddb5c',
                            max_connections=2)

r = redis.StrictRedis(connection_pool=pool)