import time
import multiprocessing
import stopwatch
import bottle
from bottle import route

__lapsedtime__ = 0
__t__ = None
@bottle.post('/')
def return_home():
	flag = bottle.request.forms.get("timer")
	print flag
	global __t__
	print flag
	if(flag == "Start"):
		__t__ = stopwatch.Timer()
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

@route("/views/:filename#.*#")
def return_static(filename):
	return bottle.static_file(filename, root='views/')	

@route('/')
def return_page():
	return bottle.template("index")

bottle.debug(True)

bottle.run(host='localhost', port =8080)
