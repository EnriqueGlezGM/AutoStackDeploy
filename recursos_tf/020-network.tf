#### NETWORK CONFIGURATION ####

# Router creation
resource "openstack_networking_router_v2" "r1" {
  name                = "r1"
  external_network_id = var.external_gateway
}

# Network creation
resource "openstack_networking_network_v2" "net1" {
  name = "net1"
}

# Network creation net2
resource "openstack_networking_network_v2" "net2" {
  name = "net2"
}

#### HTTP SUBNET ####

# Subnet 1 configuration
resource "openstack_networking_subnet_v2" "subnet1" {
  name            = var.network_http["subnet_name"]
  network_id      = openstack_networking_network_v2.net1.id
  cidr            = var.network_http["cidr"]
  dns_nameservers = var.dns_ip
}

# Router interface configuration
resource "openstack_networking_router_interface_v2" "subnet1" {
  router_id = openstack_networking_router_v2.r1.id
  subnet_id = openstack_networking_subnet_v2.subnet1.id
}

#### DB NETWORK ####

# Subnet 2 configuration
resource "openstack_networking_subnet_v2" "subnet2" {
  name            = var.network_db["subnet_name"]
  network_id      = openstack_networking_network_v2.net2.id
  cidr            = var.network_db["cidr"]
  dns_nameservers = var.dns_ip
}



