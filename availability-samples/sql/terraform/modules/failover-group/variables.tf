variable "name" {
  type        = string
  description = "Name of the storage account"
}

variable "server_id" {
  type        = string
  description = "ID of the SQL server"
}
variable "partner_server_id" {
  type        = string
  description = "ID of the SQL server"
}
variable "databases" {
  type = list(string)
}
