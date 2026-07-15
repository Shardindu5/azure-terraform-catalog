variable "template_key" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "location" {
  type = string
}

variable "environment" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "resource_name" {
  type = string
}

variable "sku_or_size" {
  type = string
}

variable "owner" {
  type = string
}

variable "cost_center" {
  type = string
}

variable "request_id" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
