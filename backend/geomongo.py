from pprint import pprint

from gevent import monkey; monkey.patch_all()
from pymongo import Connection, GEO2D
from bson.son import SON
db = Connection().geo_example
db.places.create_index([("loc", GEO2D)])

EARTH_RADIUS = 6378.0

def post_ad(media, lat, lng, text=None):
    result = str(db.places.insert({"media": media, "loc": [lat, lng], "text": text}))
    db.places.ensure_index([("loc", GEO2D)])
    return {'id': result}

def get_ads(swlat, swlng, nelat, nelng, categories, q):
    box = [[swlat, swlng], [nelat,  nelng]]
    #return [ad for ad in db.places.find({"loc": {"$within": {"$box": box}}})]
    # JS= distances = db.runCommand({ geoNear : "points", near : [0, 0], spherical : true, maxDistance : range / earthRadius /* to radians */ }).results

    db.places.ensure_index([("loc", GEO2D)])
    dbresult = db.places.find({"loc": {"$within": {"$box": box}}})
    #dbresult = db.command(SON([('$within', 'places'),
    #                ('$box', box),])
    #                )
    result = []
    pprint(dbresult)
    for rec in dbresult:
        pprint(rec)
        result.append(
            {'id': str(rec['obj']['_id']),
             'text': rec['obj']['text'],
             'media': rec['obj']['media'],
             'latlng': rec['obj']['loc'],
             })
    return result