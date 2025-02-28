# HTTP LOAD BALANCER CONFIGURATION
#
# Create loadbalancer
resource "openstack_lb_loadbalancer_v2" "http" {
  name          = "elastic_loadbalancer_http"
  vip_subnet_id = openstack_networking_subnet_v2.subnet1.id
  depends_on    = [openstack_compute_instance_v2.http]
}

# Create listener
resource "openstack_lb_listener_v2" "http" {
  name            = "listener_http"
  protocol        = "TCP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.http.id
  depends_on      = [openstack_lb_loadbalancer_v2.http]
}

# Set methode for load balance charge between instance
resource "openstack_lb_pool_v2" "http" {
  name        = "pool_http"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.http.id
  depends_on  = [openstack_lb_listener_v2.http]
}

# Add multip instances to pool
resource "openstack_lb_member_v2" "http" {
  for_each      = var.http_instance_names
  address       = openstack_compute_instance_v2.http[each.key].access_ip_v4
  protocol_port = 80
  pool_id       = openstack_lb_pool_v2.http.id
  subnet_id     = openstack_networking_subnet_v2.subnet1.id
  depends_on    = [openstack_lb_pool_v2.http]
}

# Create health monitor for check services instances status
resource "openstack_lb_monitor_v2" "http" {
  name        = "monitor_http"
  pool_id     = openstack_lb_pool_v2.http.id
  type        = "TCP"
  delay       = 2
  timeout     = 2
  max_retries = 2
  depends_on  = [openstack_lb_member_v2.http]
}

resource "openstack_networking_floatingip_v2" "lb_floating_ip" {
  pool = var.external_network
}

resource "openstack_networking_floatingip_associate_v2" "lb_floating_ip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.lb_floating_ip.address
  port_id     = openstack_lb_loadbalancer_v2.http.vip_port_id
}