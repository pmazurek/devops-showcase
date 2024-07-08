#!/bin/bash

INV_FILE=inventory.ini
ECR_URL=$(terraform output -json | jq -r .ecr_frontend_repo.value | sed 's/\/.*//')
ECR_FRONTEND_REPO=$(terraform output -json | jq -r .ecr_frontend_repo.value)
ECR_BACKEND_REPO=$(terraform output -json | jq -r .ecr_backend_repo.value)
ECR_DOCKER_PASS=$(aws ecr get-login-password)

ensure_known_hosts () {
    echo "Adding $1 ($2) to known hosts..."
    ssh-keygen -R $2 1>/dev/null 2>/dev/null | true &
    ssh-keyscan -H $2 >> ~/.ssh/known_hosts 2>/dev/null &
    ssh-keyscan -H $1 >> ~/.ssh/known_hosts  2>/dev/null &
}

OUT=""

echo "" > $INV_FILE

echo "[all:vars]" >> $INV_FILE
echo "ecr_url=$ECR_URL" >> $INV_FILE
echo "ecr_frontend_repo=$ECR_FRONTEND_REPO" >> $INV_FILE
echo "ecr_backend_repo=$ECR_BACKEND_REPO" >> $INV_FILE
echo "ecr_docker_pass=$ECR_DOCKER_PASS" >> $INV_FILE

echo "" >> $INV_FILE

add_host_group () {
    echo "[$2]" >> $INV_FILE
    counter=1
    for IP in `terraform output -json | jq -r .$1.value[][]`
    do
        hostname=$2-$counter
        echo $IP hostname=$hostname >> $INV_FILE
        OUT="$OUT\n$IP $hostname"
        ensure_known_hosts $IP $hostname
        ((counter=counter+1))
    done
    echo "" >> $INV_FILE
}

add_host_group kube_control_plane_nodes kube-control
add_host_group kube_worker_nodes kube-workers
add_host_group kube_control_plane_loadbalancer kube-control-loadbalancers
add_host_group kube_prometheus_instances prometheus-instances
add_host_group cassandra_instances cassandra-instances

wait # wait for all the ampersand tasks to finish

echo ""
echo -e "Results saved as Ansible inventory in '\033[1m$INV_FILE\033[0m'"
echo "Adding all IP's to known_hosts"
echo "Outputting /etc/hosts format to stdout to copy paste:"

echo -e $OUT

mv inventory.ini ../ansible

aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_URL
