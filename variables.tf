variable "region" {}
variable "cluster_name" {}
variable "node_group_name" {}
variable "subnet_ids" {
  type = list(string)
}
variable "cluster_version" {}
variable "desired_size" {}
variable "min_size" {}
variable "max_size" {}
variable "instance_types" {
  type = list(string)
}
variable "ami_type" {}
variable "capacity_type" {}
variable "labels" {
  type = map(string)
}
variable "tags" {
  type = map(string)
}
