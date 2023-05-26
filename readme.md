Python Hello World in Flask on Docker with simple Prometheus workload monitoring setup
=
The objective of this simple example is to demonstrate a flask web app using the Prometheus observability capabilities to 
support the monitoring of workload metrics (e.g. what endpoints where being called and how often) and workload health data (e.g. how long is it taking for methods to complete etc). The /metrics endpoint implements the output of the prometheus data using a flask specific helper  

Overview
-
- The prometheus_client library for python https://github.com/prometheus/client_python is imported. To simplify the provision of the "metrics" endpoint
- The prometheus_flask_exporter library https://pypi.org/project/prometheus-flask-exporter/ provides built in support for the implementation of the /metrics/ endpoint used to transmit the relevant metrics to a prometheus compatible data collector
- The dockerfiles in the repo use the VS Code defaults for Python including the image: `python:3.10-slim` 
- Debugging in VS Code can be done running locally or by running in the container by configuring the launch file as per https://code.visualstudio.com/docs/containers/quickstart-python
- Docker needed locally to run the containerised launch option 

Demo
-
- In VS Code use  debug to run the solution locally or using the containerised version (if Docker running locally)
- http://127.0.0.1/5000/hello/yourname to invoke the Hello World method and generate workload metrics (counter increments)
- http://127.0.0.1/5000/metrics to view the exported prometheus observability metrics  
- if using containersied example, as above but with alternate IP and port numbers 

Deploying the container to Azure 
- 
- The Azure Cloud Shell and Azure CLI can be used to deploy the resulting container into a container registry in Azure and create a running container instance. See https://learn.microsoft.com/en-us/azure/container-instances/container-instances-tutorial-prepare-acr for more details on this process
- See `AzureContainerDeploy.sh` for example Azure CLI fragments
 
GitHub action to deploy to Azure ACR Container Instance
- 
The Deploy2AzACR.YML file is used to automate an image build and deployment to Azure ACR
Note that the YAML file contains a hard coded  Container Instance name 
