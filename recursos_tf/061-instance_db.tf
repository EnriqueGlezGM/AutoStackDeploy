resource "openstack_compute_instance_v2" "db" {
  for_each    = var.db_instance_names
  name        = each.key
  image_name  = var.image
  flavor_name = var.flavor
  key_pair    = openstack_compute_keypair_v2.user_key.name
user_data = <<-EOT
  #cloud-config
package_update: true
packages:
  - sqlite3

runcmd:
  - |
    sqlite3 /home/ubuntu/example.db <<EOF
    CREATE TABLE IF NOT EXISTS usuarios (
        id INTEGER PRIMARY KEY,
        nombre TEXT NOT NULL,
        edad INTEGER,
        email TEXT
    );

    INSERT INTO usuarios (nombre, edad, email) VALUES 
        ('Alice', 30, 'alice@example.com'),
        ('Bob', 25, 'bob@example.com'),
        ('Carlos', 40, 'carlos@example.com');
    EOF
  - echo "Base de datos de ejemplo creada en /home/ubuntu/example.db" > /var/log/cloud-init-sqlite.log
  - sqlite3 /home/ubuntu/example.db "SELECT * FROM usuarios;" > /home/ubuntu/db_creation_log.txt

  EOT
  network {
    port = openstack_networking_port_v2.port_net1_bbdd[each.key].id
  }
  network {
    port = openstack_networking_port_v2.port_net2_bbdd[each.key].id
  }
}



# Create network port para net1
resource "openstack_networking_port_v2" "port_net1_bbdd" {
  for_each       = var.db_instance_names
  name           = "port-net1-${each.key}"
  network_id     = openstack_networking_network_v2.net1.id
  admin_state_up = true
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet1.id
  }
  security_group_ids = [
    openstack_compute_secgroup_v2.http.id,
    openstack_compute_secgroup_v2.ssh.id,
  ]
}

# Create network port para net2
resource "openstack_networking_port_v2" "port_net2_bbdd" {
  for_each       = var.db_instance_names
  name           = "port-net2-${each.key}"
  network_id     = openstack_networking_network_v2.net2.id
  admin_state_up = true
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet2.id
  }
  security_group_ids = [
    openstack_compute_secgroup_v2.http.id,
    openstack_compute_secgroup_v2.ssh.id,
  ]
}

