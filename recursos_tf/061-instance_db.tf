#### INSTANCE DB ####

# Create instance
#
resource "openstack_compute_instance_v2" "db" {
  for_each    = var.db_instance_names
  name        = each.key
  image_name  = var.image
  flavor_name = var.flavor
  key_pair    = openstack_compute_keypair_v2.user_key.name
  user_data = <<-EOF
  #cloud-config
  package_update: true
  packages:
  - mongodb
  runcmd:
  - echo "Configuración inicial de MongoDB" >> /var/log/cloud-init.log
  - systemctl start mongodb
  EOF
  network {
    port = openstack_networking_port_v2.db[each.key].id
  }
  security_groups = [openstack_networking_secgroup_v2.my_security_group.name]
}

# Create network port
resource "openstack_networking_port_v2" "db" {
  for_each       = var.db_instance_names
  name           = "port-BBDD-${each.key}"
  network_id     = openstack_networking_network_v2.net2.id
  admin_state_up = true
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet2.id
  }
}

