#### INSTANCE HTTP ####

# Create instance
#
resource "openstack_compute_instance_v2" "http" {
  for_each    = var.http_instance_names
  name        = each.key
  image_name  = var.image
  flavor_name = var.flavor
  key_pair    = openstack_compute_keypair_v2.user_key.name
  user_data = <<-EOT
  #cloud-config
packages:
  - nginx
runcmd:
  - echo "<html><body><h1>Servicio web ${each.key}</h1></body></html>" > /var/www/html/index.nginx-debian.html
  - systemctl restart nginx
  EOT
  network {
    port = openstack_networking_port_v2.port_net1[each.key].id
  }
  network {
    port = openstack_networking_port_v2.port_net2[each.key].id
  }
}

# Create network port para net1
resource "openstack_networking_port_v2" "port_net1" {
  for_each       = var.http_instance_names
  name           = "port-net1-${each.key}"
  network_id     = openstack_networking_network_v2.net1.id
  admin_state_up = true
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet1.id
  }
  security_group_ids = [
    openstack_compute_secgroup_v2.http.id,
  ]
}

# Create network port para net2
resource "openstack_networking_port_v2" "port_net2" {
  for_each       = var.http_instance_names
  name           = "port-net2-${each.key}"
  network_id     = openstack_networking_network_v2.net2.id
  admin_state_up = true
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet2.id
  }
  security_group_ids = [
    openstack_compute_secgroup_v2.http.id,
  ]
}





resource "openstack_compute_instance_v2" "admin" {
  name        = "admin"
  image_name  = var.image
  flavor_name = var.flavor
  key_pair    = openstack_compute_keypair_v2.user_key.name
  network {
    port = openstack_networking_port_v2.port_net1_admin.id
  }
  network {
    port = openstack_networking_port_v2.port_net2_admin.id
  }
}

# Create network port_admin para net1
resource "openstack_networking_port_v2" "port_net1_admin" {
  name           = "port_net1_admin"
  network_id     = openstack_networking_network_v2.net1.id
  admin_state_up = true
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet1.id
  }
  security_group_ids = [
    openstack_compute_secgroup_v2.http.id,
  ]
}

# Create network port_admin para net2
resource "openstack_networking_port_v2" "port_net2_admin" {
  name           = "port_net2_admin"
  network_id     = openstack_networking_network_v2.net2.id
  admin_state_up = true
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet2.id
  }
  security_group_ids = [
    openstack_compute_secgroup_v2.http.id,
  ]
}

# Crear IP flotante y asociarla a la instancia 'admin'
resource "openstack_networking_floatingip_v2" "admin_floating_ip" {
  pool = var.external_network
}

resource "openstack_compute_floatingip_associate_v2" "admin_floating_ip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.admin_floating_ip.address
  instance_id = openstack_compute_instance_v2.admin.id
}