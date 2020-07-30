#####################################################
# Terraform - to build infrastructure
#####################################################
##cd Terraform/
#terraform plan 
#terraform apply -auto-approve
#IP_SQL=$(terraform output)
##cd ..

#####################################################
# Base Layer image Build
# Uncomment next line in order to rebuild base layer
# docker build -t baselayer_ol7:latest -f "$(pwd)/Docker/BaseLayer.dockerfile" . --no-cache
#####################################################

#####################################################
# Application image build
#####################################################
#docker build -t 23p-api-lab:latest -f "$(pwd)/Docker/23p-api-lab.dockerfile" . --no-cache

#####################################################
# Tag and push to container repository
#####################################################
#docker tag $(docker images 23p-api-lab -q) us.gcr.io/alien-bruin-284822/23p-api-lab:latest
#docker push us.gcr.io/alien-bruin-284822/23p-api-lab:latest
#kubectl rollout restart deploy/p23
#####################################################
# K8s -manage and expose Pods
#####################################################
#gcloud container clusters get-credentials p23-cluster --region us-central1 --project alien-bruin-284822
# Create Pods
#kubectl create -f k8s/d_Pod.yml
# Create ClusterIp Service
#kubectl create -f k8s/s_Cluster.yml
# Create NodePort Service
#kubectl create -f k8s/s_NodePort.yml
# Add ingress rule to firewall
#gcloud compute firewall-rules create p23-external-access --allow tcp:32532
# Forze Rollout latest image
#kubectl rollout restart deploy/p23
# Get node ip
#kubectl get nodes -o wide

#########################################
# Resume
#########################################

#gcloud container clusters get-credentials p23-cluster --region us-central1 --project alien-bruin-284822
#kubectl rollout restart deploy/p23
#kubectl get nodes -o wide
#cd Terraform/
#terraform output
#cd ..