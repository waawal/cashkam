from pprint import pprint

from pymongo import Connection, GEO2D
from bson.son import SON
db = Connection().geo_example
db.places.create_index([("loc", GEO2D)])

EARTH_RADIUS = 6378

def post_ad(media, lat, lng, text=None):
    result = str(db.places.insert({"media": media, "loc": [lat, lng], "text": text}))
    db.places.ensure_index([("loc", GEO2D)])
    return {'id': result}

def get_ads(lat, lng, radius, categories, q):
    #box = [[swlat, swlng], [nelat,  nelng]]
    #return [ad for ad in db.places.find({"loc": {"$within": {"$box": box}}})]
    # JS= distances = db.runCommand({ geoNear : "points", near : [0, 0], spherical : true, maxDistance : range / earthRadius /* to radians */ }).results
    maxdistance = float((float(radius/1000) / float(EARTH_RADIUS)))
    print "maxdist", maxdistance

    db.places.ensure_index([("loc", GEO2D)])
    dbresult = db.command(SON([('geoNear', 'places'),
                    ('near', [lat, lng]),
                    ('spherical', True),
                    ('maxDistance', maxdistance)])
                    )
    result = []
    for rec in dbresult['results']:
        result.append(
            {'id': str(rec['obj']['_id']),
             'text': rec['obj']['text'],
             'media': rec['obj']['media']})
    return result