
# Why ubuntu? Because I never used it before and wanted to learn/play/see

data "aws_ami" "latest-ubuntu" {
most_recent = true
owners = ["099720109477"] # Canonical

  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}

data "aws_ami" "latest-debian" {
most_recent = true
owners = ["136693071363"] # Amazon

  filter {
      name   = "name"
      values = ["debian-11-amd64-*"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}


resource "aws_instance" "control_plane" {
  count = 2

  ami                    = "${data.aws_ami.latest-ubuntu.id}"
  instance_type          = "t2.medium"
  key_name               = "${aws_key_pair.main_ssh_key.key_name}"
  monitoring             = false
  vpc_security_group_ids = ["${aws_default_security_group.default.id}", "${aws_security_group.allow_ssh.id}"]
  subnet_id              = "${aws_subnet.main.id}"
  associate_public_ip_address = true

  tags = {
    Name = "kube-control-plane"
  }
}

resource "aws_instance" "control_plane_loadbalancer" {
  count = 2

  ami                    = "${data.aws_ami.latest-ubuntu.id}"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.main_ssh_key.key_name}"
  monitoring             = false
  vpc_security_group_ids = ["${aws_default_security_group.default.id}", "${aws_security_group.allow_ssh.id}"]
  subnet_id              = "${aws_subnet.main.id}"
  associate_public_ip_address = true

  tags = {
    Name = "kube-control-plane-loadbalancer"
  }
}

resource "aws_instance" "worker_nodes" {
  count = 1

  ami                    = "${data.aws_ami.latest-ubuntu.id}"
  instance_type          = "t2.medium"
  key_name               = "${aws_key_pair.main_ssh_key.key_name}"
  monitoring             = false
  vpc_security_group_ids = ["${aws_default_security_group.default.id}", "${aws_security_group.allow_ssh.id}"]
  subnet_id              = "${aws_subnet.main.id}"
  associate_public_ip_address = true

  tags = {
    Name = "kube-worker-node"
  }
}

resource "aws_instance" "prometheus" {
  count = 1

  ami                    = "${data.aws_ami.latest-ubuntu.id}"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.main_ssh_key.key_name}"
  monitoring             = false
  vpc_security_group_ids = ["${aws_default_security_group.default.id}", "${aws_security_group.allow_ssh.id}"]
  subnet_id              = "${aws_subnet.main.id}"
  associate_public_ip_address = true

  tags = {
    Name = "prometheus"
  }
}

resource "aws_instance" "cassandra" {
  count = 2

  ami                    = "${data.aws_ami.latest-ubuntu.id}"
  instance_type          = "t2.medium"
  key_name               = "${aws_key_pair.main_ssh_key.key_name}"
  monitoring             = false
  vpc_security_group_ids = ["${aws_default_security_group.default.id}", "${aws_security_group.allow_ssh.id}"]
  subnet_id              = "${aws_subnet.main.id}"
  associate_public_ip_address = true

  tags = {
    Name = "cassandra"
  }
}

output "kube_control_plane_nodes" {
  value = ["${aws_instance.control_plane.*.public_ip}"]
}
output "kube_control_plane_loadbalancer" {
  value = ["${aws_instance.control_plane_loadbalancer.*.public_ip}"]
}
output "kube_worker_nodes" {
  value = ["${aws_instance.worker_nodes.*.public_ip}"]
}
output "kube_prometheus_instances" {
  value = ["${aws_instance.prometheus.*.public_ip}"]
}
output "cassandra_instances" {
  value = ["${aws_instance.cassandra.*.public_ip}"]
}
