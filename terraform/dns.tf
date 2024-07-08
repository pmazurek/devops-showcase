resource "aws_route53_zone" "private" {
  name = "internal.zone"

  vpc {
    vpc_id = aws_vpc.main_vpc.id
  }
}

resource "aws_route53_record" "kube_loadbalancer_dns" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "kube-loadbalancer.internal.zone"
  type    = "A"
  ttl     = "30"
  records = toset(aws_instance.control_plane_loadbalancer.*.private_ip)
}
