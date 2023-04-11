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

variable "active_directory_group" {
  type        = string
  description = "Active Directory Group Name"
  default     = "DTS SDS Developers"
}

variable "jenkins_identity_object_id" {
  description = "Objectid for jenkins managed identity"
  default     = "7ef3b6ce-3974-41ab-8512-c3ef4bb8ae01"
}

variable "key_vault_id" {
  description = "Key Vault ID"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  type = list(object({
    name            = string
    value           = string
    tags            = map(string)
    content_type    = string
    expiration_date = optional(string)
  }))
  description = "Define Azure Key Vault secrets"
  default     = []
}