"""Worker for cashkam """


try:
    import cStringIO as StringIO
except ImportError:
    import StringIO

from base64 import b64decode
#import mongodb
from fabric.api import env, run
from fabric.operations import put

env.port = 22 # 10022 in prod.
env.use_shell = False
env.pool_size = 3

env.user = 'img'
env.host_string = '192.168.0.240'
#env.hosts = ['192.168.0.240']
env.password = "image1234" # TODO! .pub-keys pls!!!

def put_file(fileobj, name, size):
    # http://docs.fabfile.org/en/1.4.3/api/core/operations.html#fabric.operations.put
    namepath = "".join(('images/', size, "/", name, ".jpg"))
    put(fileobj, namepath, mode=660)

def resize(image, name):
    image = StringIO.StringIO(b64decode(image))
    size = 'small'
    put_file(image, name, size)

#data = 'iVBORw0KGgoAAAANSUhEUgAAADIAAAADCAIAAABee8vuAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAB1JREFUeNpi/P79O8PgAyzMzMyD0FlMDIMSAAQYAC22AvZUamhbAAAAAElFTkSuQmCC'
#resize(data, "test")