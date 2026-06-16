variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "node_vm_size" {
  type = string
}

variable "tags" {
  type = map(string)
}