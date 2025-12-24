variable "name" {
  type        = string
  description = "The name for the Cosmos DB account."
}
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}
variable "cosmos_account_name" {
  type        = string
  description = "The name of the Cosmos DB account."
}
variable "cosmos_database_name" {
  type        = string
  description = "The name of the Cosmos DB database."
}
variable "max_throughput" {
  type        = number
  description = "The maximum throughput for the Cosmos DB SQL database."
}