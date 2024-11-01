# Acces group, open input port 80 and ssh port
resource "openstack_compute_secgroup_v2" "http" {
  name        = "http"
  description = "Open input http port"
  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_networking_secgroup_v2" "my_security_group" {
 name = "open"
 description = "Grupo de Seguridad para permitir todo el trafico"
 delete_default_rules = true
}
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_ingress"{
 direction = "ingress"
 ethertype = "IPv4"
 protocol = "tcp"
 remote_ip_prefix = "0.0.0.0/0"
 security_group_id = openstack_networking_secgroup_v2.my_security_group.id
}
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_engress"{
 direction = "egress"
 ethertype = "IPv4"
 protocol = "tcp"
 remote_ip_prefix = "0.0.0.0/0"
 security_group_id = openstack_networking_secgroup_v2.my_security_group.id
}