# Sample kubernetes deployment

This is an example deployment based on __ansible, terraform, bash__ and __AWS__ made for *educational and recruitment* purposes.

Feel free to browse around to get the hang of my coding style and skillset.

Also feel free to use it however you please as it might actually be quite useful for a kick start of a real deployment, or at least a copy-paste reference.

This includes (so far):
* Terraform scripts to set up the needed infrastructure on AWS (VPC, subnets, routing, SSH keys, EC2 instances, private Route53 zone, etc),
* Ansible playbooks which fully install, set up, and bootstrap:
    * __Kubernetes cluster with High Availability__ (2x control plane + 2x loadbalancing, any number of worker nodes) including creating and joining the cluster etc,
    *  __Apache Cassandra__ cluster (any number of nodes),
    *  __Prometheus__ monitoring instance,
* __Bash scripts__ to make it all fully automatic

## Usage

#### Prep

* Prepare an environment to run it (AWS, I used playgrounds on acloud.guru),
* Update your AWS credentials (`~/.aws/credentials`),
* Update the SSH key in `terraform/ssh_keys.tf` to your public key hash,

#### Infrastructure

* Go to `./terraform` and run `terraform apply`,
* Run `./setup_inventory.sh` (recommended to copy-paste the output to your `/etc/hosts`) - this will populate the inventory with all the required IPs and move it to ansible folder,

#### Installation

* Cd back to `../ansible`,
* Run `./setup_stack.sh` which will set up the entire stack with ansible, or simply proceed with running the playbooks listed there on your own, but do follow the order as set in this file.

#### Playing around

To play around with it I recommend setting up dynamic forwarding:

`ssh ubuntu@kube-control-1 -D 1234 -N &`
(note the domain only works if you copy-pasted into /etc/hosts during setting up the Infrastructure step, if you didnt, use IP)

And then set up a localhost:1234 proxy on any browser.

For example in Firefox this would be: settings -> search for "proxy" and click on it -> "Manual proxy configuration", SOCKS host to `localhost`, port to `1234`, and check `Proxy DNS when using SOCKS v5`.

This will ensure you can visit the entire infrastructure from this browser, for example address like `http://prometheus-instances-1:9090/targets` should show prometheus UI.

Just a note for whoever might be worried about security: don't worry, it's NOT public, no one else than you has access to this address.

## Playbooks included

Install the dependencies

- kube-common.yml; Common tasks for all kubernetes nodes, setting up kernel modules, installation of containerd, kubelet kubeadm etc etc
- kube-ha-init.yml; High availablility setup for kubernetes control plane
- kube-load-balancer.

- 2x control plane nodes
- 2x loadbalancing nodes
- 2x worker nodes
- Calico network plugin
- HA kubernetes cluster
- private domain zone on route53 for the load banacers,

Order
- Kube common
- Kube loadbalancers
- Kube ha init
- kube join nodes
