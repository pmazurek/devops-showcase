set -ex

ansible-playbook -b -i inventory.ini -u ubuntu common-playbook.yml
ansible-playbook -b -i inventory.ini -u ubuntu initialize-the-cluster-playbook.yml &
ansible-playbook -b -i inventory.ini -u ubuntu prometheus-playbook.yml &
ansible-playbook -b -i inventory.ini -u ubuntu prometheus-node-exporter-playbook.yml &
ansible-playbook -b -i inventory.ini -u ubuntu cassandra-init-playbook.yml -e init_cluster=yes &

wait

