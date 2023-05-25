# this shell script file contains useful fragments of code for deploying to Azure Container Instances
# do not expect to run this file end to end -  you will need to copy and paste the code fragments into your own shell script file
# (this file is intended to be a reference for the code fragments you will need to deploy to Azure Container Instances)

#create the Azure resource group 
#az group create --name <ResourceGroup> --location <Aazurelocation>
az group create --name AFlaskmyRG --location eastus

#create the Azure container registry that will hold the container image
#<acrName> must be unique across Azure
#az acr create --resource-group AFlaskmyRG --name <acrName> --sku Basic 
az acr create --resource-group AFlaskmyRG --name a1tenacregistry --sku Basic

#login to the Azure container registry
#az acr login --name <acrName>
az acr login --name a1tenacregistry
#alternately use the below docker login in the Azure CLI 
az acr login --name a1tenacregistry --expose-token # will return a token that can be used to login to the registry
docker login <loginServer> -u 00000000-0000-0000-0000-000000000000 -p <access_token>

#To push a container image to a private registry like Azure Container Registry, 
#you must first tag the image with the full name of the registry's login server.
#If the login server is not already known:
#az acr show --name <acrName> --query loginServer --output table
az acr show --name a1tenacregistry --query loginServer --output table

#using docker CLI locally, or Docker client or VS Code Docker extension, list the docker images to get the name of your image 
docker images

#To register the image, it must be appropriately tagged
#Use the docker CLI to Tag the aci-tutorial-app image with the login server of your container registry
#add the :v1 tag to the end of the image name to indicate the image version number. 
#Replace <acrLoginServer> with the result of the az acr show command you executed earlier.
#Alertnatively, you can use the docker tag command to tag the image.
#alertnatively, you can use the Docker extension in VS Code to tag the image 

docker tag <yourimagename> <acrLoginServer>/<yourimagename>:v1

#Use the docker CLI to push the tagged image to your container registry
#Alternitively, you can use the Docker extension in VS Code to push the image to the registry

docker push acrLoginServer>/<yourimagename>:v1

#to verify that the image you just pushed is indeed in your Azure container registry, list the images in your registry with the az acr repository list command
az acr repository list --name a1tenacregistry --output table

#To see the tags for a specific image, use the az acr repository show-tags command.
az acr repository show-tags --name a1tenacregistry --repository  <yourimagename> --output table

#When you deploy an image that's hosted in a private Azure container registry 
#in a "headless" or unattended manner you must supply credentials to access the registry.
# To generate an appropriately proiveleged servive principal, run  the script found at the below link in the Azure Cloud Shell  
# https://learn.microsoft.com/en-us/azure/container-registry/container-registry-auth-aci 
# A copy of the shell is also in this repo as create_service_principal_helper.sh

#Do *not* store the returned credentials in a file or in source control.
#Instead, supply them as environment variables at runtime.
# remember to update all the parameters in the script to match your environment

az container create \
    --resource-group myResourceGroup \
    --name mycontainer \
    --image a1tenacregistry.azurecr.io/myimage:v1 \
    --registry-login-server mycontainerregistry.azurecr.io \
    --registry-username <service-principal-ID> \
    --registry-password <service-principal-password>

#This will create a container instance named <mycontainer> in the resource group myResourceGroup.
#remember to stop any running containers or related resources that are not needed to avoid incurring charges