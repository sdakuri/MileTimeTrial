#!/usr/bin/env python
# Mile Time Trial application
# Create runners, associate bib no with the runner. Create a relay of runners. 
# Time a group of runners by selecting the appropriate relay.
import time
import multiprocessing
import stopwatch
import bottle
from bottle import route
import pymongo
import sys
import os 

__author__ = "Shashidhar Dakuri"
__copyright__ = "Copyright 2013, Team Asha MTT project"
__credits__ = ['John Paulett <http://blog.7oars.com> for the stopwatch module' ]
__license__ = "GPL"
__version__ = "1.0.0"
__maintainer__ = "Shashidhar Dakuri"
__email__ = "shashidhar.dakuri@gmail.com"
__status__ = "Beta"

# connection = pymongo.Connection(os.environ['OPENSHIFT_MONGODB_DB_HOST'],
#                                int(os.environ['OPENSHIFT_MONGODB_DB_PORT']))
# db = connection[os.environ['OPENSHIFT_APP_NAME']]
# db.authenticate(os.environ['OPENSHIFT_MONGODB_DB_USERNAME'],
#                       os.environ['OPENSHIFT_MONGODB_DB_PASSWORD'])

MONGO_URL = os.environ.get('MONGOHQ_URL')

if MONGO_URL:
	connection = pymongo.MongoClient(MONGO_URL)
	db = connection.runners
else:
	connection = pymongo.MongoClient("mongodb://localhost")
	db = connection.runners

runners_collection = db.runners
relays_collection = db.relays
timing_collection = db.timing

__lapsedtime__ = 0
__t__ = None

def format_time(raw_time):
	s = raw_time
	d = int(s / 86400)
	s -= d * 86400
	h = int(s / 3600)
	s -= h * 3600
	m = int(s / 60)
	s -= m * 60
	return str.format("\r %02d:%02d:%04.1f" % (h, m, s))


@bottle.post('/')
def return_home():
	flag = bottle.request.forms.get("timer")
	global __t__
	global __lapsedtime__
	if(flag == "Start"):		
		__t__ = stopwatch.Timer()
	elif(flag == "Stop"):
		__t__.stop()
		__t__ = None
		__lapsedtime__ = 0
		return None	
	else:
		return bottle.redirect("/")			
	
@bottle.get('/get_time')
def ret_time():
	global __lapsedtime__
	s = __t__.elapsed
	d = int(s / 86400)
	s -= d * 86400
	h = int(s / 3600)
	s -= h * 3600
	m = int(s / 60)
	s -= m * 60
	__lapsedtime__ = str.format("\r %02d:%02d:%04.1f" % (h, m, s))
	return __lapsedtime__

@route("/static/:filename#.*#")
def return_static(filename):
	return bottle.static_file(filename, root='static/')	

@route('/')
def return_page():
	relays = relays_collection.find()
	relays_list =[]
	for relay in relays:
		relays_list.append({'relay_number':relay['relay_number']}) 
	return bottle.template("index", dict(relays=relays_list))

@route('/manage')	
def manage_users():
	try:
		runners = runners_collection.find()
		runners_list = []
		for runner in runners:
			runners_list.append({'bib_no':runner['bib'],'name':runner['name']})

		relays = relays_collection.find()
		relays_list =[]
		for relay in relays:
			relays_list.append({'relay_no':relay['relay_number'],'relay_runners':relay['relay_runners']})
	except:
		print "error", sys.exc_info()

	return bottle.template("manage", dict(runners=runners_list, relays=relays_list))	

@bottle.post('/add_runner')
def add_runner():
	bib = bottle.request.forms.get("BibNumber")
	name = bottle.request.forms.get("Name")
	runner = {'bib': bib, 'name':name}
	try:
		runners_collection.insert(runner)		
	except:
		print "Error while adding runner", sys.exc_info()	
	bottle.redirect('/manage')

@bottle.post('/add_relay')
def add_relay():
	relay_number = bottle.request.forms.get("RelayNumber")
	relay_runners =  bottle.request.forms.getlist("Runners")
	data = {'relay_number':relay_number, 'relay_runners': relay_runners}
	try:
		relays_collection.insert(data)
	except:
		print "Error saving the relay list", sys.exc_info()	
	bottle.redirect('/manage')	

@bottle.get('/get_relay_runners')
def get_relay_runners():
	relay_number = bottle.request.query.get("relay_number")
	fields={'relay_runners':1, '_id': 0}
	query = {'relay_number':relay_number}
	runners_list = relays_collection.find_one(query,fields=fields);
	
	return runners_list

@bottle.get('/add_runner_time')
def add_runner_time():
	global __t__
	lap = 0
	lap_time  = __t__.elapsed
	total_time = __t__.elapsed
	try:
		bib_number = bottle.request.query.get("bib_no")
		relay_number = bottle.request.query.get("relay_number")
		query = {'relay_number':relay_number,'bib_number':bib_number}		
		time_entry = timing_collection.find_one(query)
		runner = runners_collection.find_one({'bib':bib_number})
		name = runner['name']
		if(time_entry==None):
			lap	= 1		
			time_entry = {'relay_number':relay_number,
							'bib_number':bib_number,
							'name':name,
							'lap_times':[{'lap':lap,'time':__t__.elapsed}]}
			timing_collection.insert(time_entry)
		else:
			lap_times = time_entry['lap_times']			
			lap = len(lap_times)
			for lap_entry in lap_times:
				lap_time -= lap_entry['time'] 
			if(lap<4):
				lap += 1
				timing_collection.update({'_id':time_entry['_id']},{'$push':{'lap_times':{'lap':lap,'time':lap_time}}}, True)			 
				if(lap==4):
					timing_collection.update({'_id':time_entry['_id']},{'$set':{'total_time':total_time}}, True)	
			
	except:
		print "Error saving the time", sys.exc_info()		
	
	return {'elapsed':format_time(lap_time),'lap':lap,'total_time':format_time(total_time)}

@route('/report')	
def return_report():
	sort = [('total_time',1)]
	results = timing_collection.find(sort=sort)
	result_list = []
	for result in results:
		laps = []
		for lap in result['lap_times']:
			laps.append({'lap':lap['lap'],
						'time':format_time(lap['time'])})
		result_list.append({'bib_number':result['bib_number'],
							'name':result['name'],
							'total_time':format_time(result['total_time']),
							'laps':laps})
	return bottle.template("report", dict(results=result_list))

try:
	bottle.run(host="0.0.0.0",port=int(os.environ.get("PORT",5000)))
except:	
	bottle.debug(True)
	bottle.run(host='localhost', port =8080)
