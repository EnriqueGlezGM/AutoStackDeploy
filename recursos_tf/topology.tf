# Variable para los nombres de los keypairs
variable "keypair_names" {
  type    = list(string)
  default = ["s1", "s2", "s3", "s4", "s5", "s6", "bbdd", "admin"]
}

# Creación de keypairs en bucle
resource "openstack_compute_keypair_v2" "keypairs" {
  count = length(var.keypair_names)
  name  = var.keypair_names[count.index]
}

#Security groups, HCL proporcionado
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

# Data source para la red externa (ExtNet)
data "openstack_networking_network_v2" "extnet" {
  name = "ExtNet"
}

# Resource para crear el router
resource "openstack_networking_router_v2" "r1" {
  name               = "r1"
  admin_state_up     = true
  external_network_id = data.openstack_networking_network_v2.extnet.id
}

# Network 1 (net1)
resource "openstack_networking_network_v2" "net1" {
  name = "net1"
}

# Subnet para Network 1 (net1)
resource "openstack_networking_subnet_v2" "subnet1" {
  name       = "subnet1"
  network_id = openstack_networking_network_v2.net1.id
  cidr       = "10.1.10.0/24"
  ip_version = 4
  dns_nameservers = ["8.8.8.8"]
  gateway_ip = "10.1.10.1"
  allocation_pool {
    start = "10.1.10.8"
    end   = "10.1.10.100"
  }
}

# Network 2 (net2)
resource "openstack_networking_network_v2" "net2" {
  name = "net2"
}

# Subnet para Network 2 (net2)
resource "openstack_networking_subnet_v2" "subnet2" {
  name       = "subnet2"
  network_id = openstack_networking_network_v2.net2.id
  cidr       = "10.1.20.0/24"
  ip_version = 4
  dns_nameservers = ["8.8.8.8"]
  gateway_ip = "10.1.20.1"
  allocation_pool {
    start = "10.1.20.8"
    end   = "10.1.20.100"
  }
}

# Interface for router to connect to subnet1 (net1)
resource "openstack_networking_router_interface_v2" "r1_interface_subnet1" {
  router_id = openstack_networking_router_v2.r1.id
  subnet_id = openstack_networking_subnet_v2.subnet1.id
}


# Data sources para las imágenes y sabores
data "openstack_images_image_v2" "jammy" {
  name = "jammy-server-cloudimg-amd64-vnx"
}
data "openstack_compute_flavor_v2" "m1-smaller" {
  name = "m1.smaller"
}

# Data sources para los keypairs
data "openstack_compute_keypair_v2" "s1_keypair" { name = "s1" }
data "openstack_compute_keypair_v2" "s2_keypair" { name = "s2" }
data "openstack_compute_keypair_v2" "s3_keypair" { name = "s3" }
data "openstack_compute_keypair_v2" "s4_keypair" { name = "s4" }
data "openstack_compute_keypair_v2" "s5_keypair" { name = "s5" }
data "openstack_compute_keypair_v2" "s6_keypair" { name = "s6" }
data "openstack_compute_keypair_v2" "admin_keypair" { name = "admin" }
data "openstack_compute_keypair_v2" "bbdd_keypair" { name = "bbdd" }

# Recursos para crear las VMs en net1 y net2
resource "openstack_compute_instance_v2" "s1" {
  name        = "s1"
  image_name  = data.openstack_images_image_v2.jammy.name
  flavor_name = data.openstack_compute_flavor_v2.m1-smaller.name
  key_pair    = data.openstack_compute_keypair_v2.s1_keypair.name
  security_groups = [openstack_networking_secgroup_v2.my_security_group.name]
  network {
    name = openstack_networking_network_v2.net1.name
  }
  network {
    name = openstack_networking_network_v2.net2.name
  }
  user_data = <<-EOT
  #!/bin/bash
  echo "S1 launched by Terraform" > /info.txt
  EOT
}
resource "openstack_compute_instance_v2" "s2" {
  name        = "s2"
  image_name  = data.openstack_images_image_v2.jammy.name
  flavor_name = data.openstack_compute_flavor_v2.m1-smaller.name
  key_pair    = data.openstack_compute_keypair_v2.s2_keypair.name
  security_groups = [openstack_networking_secgroup_v2.my_security_group.name]
  network {
    name = openstack_networking_network_v2.net1.name
  }
  network {
    name = openstack_networking_network_v2.net2.name
  }
  user_data = <<-EOT
  #!/bin/bash
  echo "S2 launched by Terraform" > /info.txt
  EOT
}
resource "openstack_compute_instance_v2" "s3" {
  name        = "s3"
  image_name  = data.openstack_images_image_v2.jammy.name
  flavor_name = data.openstack_compute_flavor_v2.m1-smaller.name
  key_pair    = data.openstack_compute_keypair_v2.s3_keypair.name
  security_groups = [openstack_networking_secgroup_v2.my_security_group.name]
  network {
    name = openstack_networking_network_v2.net1.name
  }
  network {
    name = openstack_networking_network_v2.net2.name
  }
  user_data = <<-EOT
  #!/bin/bash
  echo "S3 launched by Terraform" > /info.txt
  EOT
}
resource "openstack_compute_instance_v2" "bbdd" {
  name        = "bbdd"
  image_name  = data.openstack_images_image_v2.jammy.name
  flavor_name = data.openstack_compute_flavor_v2.m1-smaller.name
  key_pair    = data.openstack_compute_keypair_v2.bbdd_keypair.name
  security_groups = [openstack_networking_secgroup_v2.my_security_group.name]
  network {
    name = openstack_networking_network_v2.net2.name
  }
  user_data = <<-EOF
  #cloud-config
  package_update: true
  packages:
  - mongodb
  - curl
  runcmd:
  - echo "Configuración inicial de MongoDB" >> /var/log/cloud-init.log
  - systemctl start mongodb
  EOF
}
resource "openstack_compute_instance_v2" "admin" {
  name        = "admin"
  image_name  = data.openstack_images_image_v2.jammy.name
  flavor_name = data.openstack_compute_flavor_v2.m1-smaller.name
  key_pair    = data.openstack_compute_keypair_v2.admin_keypair.name
  security_groups = [openstack_networking_secgroup_v2.my_security_group.name]
  network {
    name = openstack_networking_network_v2.net2.name
  }
  user_data = <<-EOT
  #!/bin/bash
  echo "ADMIN launched by Terraform" > /info.txt
  EOT
}

# Crea la IP flotante
resource "openstack_networking_floatingip_v2" "admin_floating_ip" {
  pool = "ExtNet"
}

# Asocia la IP flotante a la instancia 'admin'
resource "openstack_compute_floatingip_associate_v2" "admin_floating_ip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.admin_floating_ip.address
  instance_id = openstack_compute_instance_v2.admin.id
}



# Crear el recurso del balanceador de tráfico
resource "openstack_lb_loadbalancer_v2" "lb" {
  name           = "loadbalancer_net1"
  vip_subnet_id  = openstack_networking_subnet_v2.subnet1.id
  vip_address    = "10.1.10.50" # La IP interna en Net1
}

# Crear un listener para el LB (por ejemplo, HTTP en puerto 80)
resource "openstack_lb_listener_v2" "lb_listener" {
  name            = "listener_http"
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
  protocol        = "HTTP"
  protocol_port   = 80
}

# Crear un pool de backend (servidores a los que el LB distribuirá el tráfico)
resource "openstack_lb_pool_v2" "lb_pool" {
  name           = "backend_pool"
  protocol       = "HTTP"
  lb_algorithm   = "ROUND_ROBIN"
  listener_id    = openstack_lb_listener_v2.lb_listener.id
}
# Crear una IP flotante
resource "openstack_networking_floatingip_v2" "lb_floating_ip" {
  pool = data.openstack_networking_network_v2.extnet.name
}

# Asignar la IP flotante al puerto VIP del balanceador
resource "openstack_networking_floatingip_associate_v2" "lb_floating_ip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.lb_floating_ip.address
  port_id     = openstack_lb_loadbalancer_v2.lb.vip_port_id
}




