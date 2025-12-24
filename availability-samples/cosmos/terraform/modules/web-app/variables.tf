variable "webappname" {
    type        = string
    description = "The name of the web app"  
}
variable "location" {
    type        = string
    description = "The location of the resource group"  
}
variable "resource_group_name" {
    type        = string
    description = "The name of the resource group"  
}

variable "app_settings" {
  type = map(string)
  default = {
    "ENV"   = "prod"
    "DEBUG" = "false"
  }
}