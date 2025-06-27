variable "cluster_name" {}
variable "subnet_ids" {
  type = list(string)
}
variable "cluster_version" {}
variable "tags" {
  type = map(string)
}
variable "eks_addons" {
  type = map(object({
    addon_version = string
  }))
  default = {}
  description = "Map of EKS addon configurations, keyed by addon name."
}
