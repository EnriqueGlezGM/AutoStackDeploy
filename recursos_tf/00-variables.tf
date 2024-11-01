# Params file for variables

#### GLANCE
variable "image" {
  type    = string
  default = "jammy-server-cloudimg-amd64-vnx"
}

#### NEUTRON
variable "external_network" {
  type    = string
  default = "ExtNet"
}

# UUID of external gateway
#variable "external_gateway" {
#  type    = string
#  default = "d30e48f6-7be9-4e66-8c25-146ee075217d"
#}

variable "dns_ip" {
  type    = list(string)
  default = ["8.8.8.8", "8.8.8.4"]
}

#### VM parameters ####
variable "flavor" {
  type    = string
  default = "m1.smaller"
}

variable "network_http" {
  type = map(string)
  default = {
    subnet_name = "subnet1"
    cidr        = "10.1.10.0/24"
  }
}

variable "http_instance_names" {
  type = set(string)
  default = ["s1",
    "s2",
  "s3"]
}


variable "network_db" {
  type = map(string)
  default = {
    subnet_name = "subnet2"
    cidr        = "10.1.20.0/24"
  }
}

variable "db_instance_names" {
  type = set(string)
  default = ["BBDD"]
}
