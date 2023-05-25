import re  # Reg Ex needed for the name filter
from flask import Flask  # needed to support the Flask infrastructure
from flask import request  # needed to support the extraction of the request path etc


from datetime import datetime  # needed to support the date/time stamp
from prometheus_flask_exporter import PrometheusMetrics #  required for Prometheus metrics flask specific implementation 
#  Note this requires requires `pip install prometheus-flask-exporter``

import prometheus_client as prom #  import 'prometheus_client', python Prometheus library

app = Flask(__name__)
metrics = PrometheusMetrics(app, group_by='endpoint') #  create a metrics object, group by endpoint (alternativel could be path etc)

# define a simple counter
appmethodcounter = prom.Counter('my_requests_total', 'HTTP Failures', ['method', 'endpoint'])
 
@app.route("/")
@metrics.counter( #  decorate the base route with prometheus counter
    'cnt_collection_base', 'Number of invocations for /', labels={
        'collection': lambda: request.path,
        'status': lambda resp: resp.status_code
    })
def home():  
    return "Hello, From root! usable paths are /hello/<name> and /metrics/" #  return a simple help string on base URL


@app.route("/hello/<name>")
@metrics.counter( #  decorate the hello route with prometheus counter
    'cnt_collection_hello', 'Number of invocations for /hello', labels={
        'collection': lambda: request.view_args['name'],
        'status': lambda resp: resp.status_code
    })
def hello_there(name):
    now = datetime.now()
    formatted_now = now.strftime("%A, %d %B, %Y at %X")

    appmethodcounter.labels(method='get', endpoint='/hello').inc()

    # Filter the name argument to letters only using regular expressions.
    # URL arguments only
    # can contain arbitrary text, so we restrict to safe characters only.
    match_object = re.match("[a-zA-Z]+", name)

    if match_object:
        clean_name = match_object.group(0)
    else:
        clean_name = "Friend"
    content = "Hello there, " + clean_name + "! It's " + formatted_now
    return content


