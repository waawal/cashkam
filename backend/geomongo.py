from pymongo import Connection, GEO2D
db = Connection().geo_example
db.places.create_index([("loc", GEO2D)])

def post_ad(media, latlng, text=None):
    return str(db.places.insert({"media": media, "loc": latlng, "text": text}))

def get_ads(lat, lng, nelat, nelng, swlat, swlng, categories):
    box = [[swlat, swlng], [nelat,  nelng]]
    return [ad for ad in db.places.find({"loc": {"$within": {"$box": box}}})]
