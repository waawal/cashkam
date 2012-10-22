import os, random
from time import strftime
from json import dumps as jsondump

import urllib2
import xml.sax

import requests

def get_lipsum(howmany, what, start_with_lipsum):
        
    class XmlHandler(xml.sax.handler.ContentHandler):
            
            def __init__(self):
                    self.lipsum = ''
                    self.generated = ''
            
            def startElement(self, name, attrs):
                    self.current_tag = name
            
            def endElement(self, name):
                    self.current_tag = None
            
            def characters(self, content):
                    if self.current_tag == 'lipsum':
                            self.lipsum += content
                    elif self.current_tag == 'generated':
                            self.generated += content
    
    query_str  = "amount=" + str(howmany)
    query_str += "&what=" + what
    query_str += "&start=" + start_with_lipsum
    
    f = urllib2.urlopen("http://www.lipsum.com/feed/xml", query_str)
    
    handler = XmlHandler()
    parser = xml.sax.make_parser()
    parser.setContentHandler(handler)
    parser.parse(f)
    
    f.close()
    
    return handler.lipsum, handler.generated

get_lipsum.__doc__ = """Get lorem ipsum text from lipsum.com. Parameters:
howmany: how many items to get
what: the type of the items [paras/words/bytes/lists]
start_with_lipsum: whether or not you want the returned text to start with Lorem ipsum [yes/no]
Returns a tuple with the generated text on the 0 index and generation statistics on index 1"""


#f = open("C:\\Data\\output\\spatial_random_sample.csv", 'w')

#How many points will be generated
numpoints = 20000 #random.randint(0,1000)

# Create the bounding box
#set longitude values - Y values
#minx = -180
#maxx = 180

minx = 40
maxx = 65

#set latitude values - X values
#miny = -23.5
#maxy = 23.5

miny = 11.5
maxy = 15.5

print "Start Time:", strftime("%a, %d %b %Y %H:%M:%S")
#Print the column headers
#print >>f, "ID",",","X",",","Y"
for x in range(0,numpoints):
#print >>f, x,",", random.uniform(minx,maxx),",",                      random.uniform(miny,maxy)
    rec = {'lat': random.uniform(minx,maxx), 'lng': random.uniform(miny,maxy),
    'media': 'http://placehold.it/200x200',
    'text': get_lipsum(random.randint(12,140), 'bytes', 'no')[0],
    'category': random.randint(0,9)
    }
    print jsondump(rec)
    r = requests.post("http://emea-fr-01.services.massforstroel.se/ads", data=jsondump(rec))
    print r.text
#f.close()

print "Script Complete, Hooray!", numpoints, "random points generated"
print "End Time:", strftime("%a, %d %b %Y %H:%M:%S")