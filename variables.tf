variable "team_name" {
  default = "HMI"
}
variable "team_contact" {
  default = "#pip-devs"
}
variable "common_tags" {
  type = map(string)
}
variable "product" {
  default = "hmi"
}
variable "location" {
  default = "UK South"
}
variable "env" {}

variable "sa_access_tier" {
  type    = string
  default = "Cool"
}
variable "sa_account_kind" {
  type    = string
  default = "StorageV2"
}
variable "sa_account_tier" {
  type    = string
  default = "Standard"
}
variable "sa_account_replication_type" {
  type    = string
  default = "RAGRS"
}