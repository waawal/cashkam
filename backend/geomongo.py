from itertools import islice

from gevent import monkey; monkey.patch_all()
from pymongo import Connection, GEO2D
from bson.son import SON
db = Connection().geo_example
db.places.create_index([("loc", GEO2D)])

EARTH_RADIUS = 6378.0
ADS_PER_REQ = 30

def post_ad(media, lat, lng, category, text=None):
    result = str(db.places.insert({"media": media, "loc": [lat, lng], "text": text, "category": category}))
    db.places.ensure_index([("loc", GEO2D)])
    return {'id': result}

#def get_ads(swlat, swlng, nelat, nelng, categories, q):
#    box = [[swlat, swlng], [nelat,  nelng]]
#    #return [ad for ad in db.places.find({"loc": {"$within": {"$box": box}}})]
#    # JS= distances = db.runCommand({ geoNear : "points", near : [0, 0], spherical : true, maxDistance : range / earthRadius /* to radians */ }).results
#
#    db.places.ensure_index([("loc", GEO2D)])
#    dbresult = db.places.find({"loc": {"$within": {"$box": box}}}).limit(20)
#    #dbresult = db.command(SON([('$within', 'places'),
#    #                ('$box', box),])
#    #                )
#    result = []
#    #pprint(dbresult)
#    for rec in dbresult:
#        #pprint(rec)
#        result.append(
#            {'id': str(rec['_id']),
#             'text': rec['text'],
#             'media': rec['media'],
#             'latlng': rec['loc'],
#             })
#    return result

def get_ads(latlng, index):
    result = []

    if not index:
        limit = 30
        #dbresult = db.places.find({"loc": {"$near": latlng}}).limit(ADS_PER_REQ)
        dbresult = db.command(SON([('geoNear', 'places'), ('near', latlng), ('num', limit), ('spherical', 'true'), ('uniqueDocs', True)]))
        for rec in dbresult['results']:
            print "first recs"
            result.append({'id': str(rec['_id']),
                           'text': rec['text'],
                           'media': rec['media'],
                           'latlng': rec['loc'],
                          })
    else:
        limit = index + ADS_PER_REQ
        dbresult = db.command(SON([('geoNear', 'places'), ('near', latlng), ('num', limit), ('spherical', 'true'), ('uniqueDocs', True)]))
        #dbresult = db.places.find({"loc": {"$near": latlng}}).limit(limit)
        for rec in islice(dbresult['results'], index, limit):
            print rec
            result.append({'id': str(rec['_id']),
                                 'text': rec['text'],
                                 'media': rec['media'],
                                 'latlng': rec['loc'],
                                })
    return result

