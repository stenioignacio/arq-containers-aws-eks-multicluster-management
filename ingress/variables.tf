variable "project_name" {
  
}
variable "project_region" {
  default = "us-east-1"
}

variable "ssm_vpc" {
  
}

variable "ssm_subnets" {
  type = list(string)
}

variable "routing_weight" {
  type = object({
    cluster_01 = number
    cluster_02 = number
  })
}