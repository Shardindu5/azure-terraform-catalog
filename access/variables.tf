variable "request_id"     { type = string }
variable "subscription_id" { type = string }
variable "environment"    { type = string }
variable "scope"          { type = string }
variable "role"           { type = string }
variable "principal_id"   { type = string }
variable "principal_type" {
  type    = string
  default = "User"
}
variable "description"    {
  type    = string
  default = ""
}