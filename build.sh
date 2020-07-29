#####################################################
# Terraform - to build infrastructure
#####################################################
cd Terraform/
terraform plan 
terraform apply -auto-approve
IP_SQL=terraform outputs
cd ..

#####################################################
# Base Layer image Build
# Uncomment next line in order to rebuild base layer
# docker build -t baselayer_ol7:latest -f "$(pwd)/Docker/BaseLayer.dockerfile" . --no-cache
#####################################################

#####################################################
# Application image build
#####################################################
docker build -t 23p-api-lab:latest -f "$(pwd)/Docker/23p-api-lab.dockerfile" . --no-cache

#####################################################
# Tag and push to container repository
#####################################################
docker tag $(docker images 23p-api-lab -q) us.gcr.io/core-waters-284316/23p-api-lab:latest
docker push us.gcr.io/core-waters-284316/23p-api-lab:latest

#####################################################
# K8s -manage and expose Pods
#####################################################
gcloud container clusters get-credentials p23-cluster --region us-central1 --project core-waters-284316
# Create Pods
kubectl create -f k8s/d_Pod.yml
# Create ClusterIp Service
kubectl create -f k8s/s_Cluster.yml
# Create NodePort Service
kubectl create -f k8s/s_NodePort.yml
# Add ingress rule to firewall
gcloud compute firewall-rules create p23-external-access --allow tcp:32532
# Forze Rollout latest image
kubectl rollout restart deploy/p23
# Get node ip
kubectl get nodes -o wide


# #####################################################
# # SQL conection
# #####################################################
# PRIMARY_ADDRESS="35.202.184.206"
# INSTANCE_NAME=gcloud sql instances list --filter=PRIMARY_ADDRESS:$PRIMARY_ADDRESS --format="value(NAME)"
# CONNECTION_NAME=gcloud sql instances describe mysqldb-23p-ap-lab --format="value(connectionName)"
# #enable worload identity
# gcloud container clusters update p23-cluster --workload-pool=core-waters-284316.svc.id.goog --zone=us-central1
# gcloud container node-pools update default-pool --cluster=p23-cluster   --workload-metadata=GKE_METADATA --zone us-central1

# gcloud iam service-accounts add-iam-policy-binding \
#   --role roles/iam.workloadIdentityUser \
#   --member "serviceAccount:core-waters-284316.svc.id.goog[default/ksa-p23]" \
#   291458883360-compute@developer.gserviceaccount.com


# kubectl create secret generic "23people" \
#   --from-literal=db_user="23people" \
#   --from-literal=db_password="23people" \
#   --from-literal=db_name="23people"
#kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json="$(pwd)/Terraform/core-waters-284316-892e73a3a61b.json"
#kubectl create secret generic cloudsql-db-credentials --from-literal=username=proxyuser --from-literal=password="23people"

