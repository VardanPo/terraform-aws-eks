variable "cluster_name" {}
variable "node_role_arn" {}
variable "subnet_ids" {}
variable "node_name" {
  default = null
}
variable "node_group_name_prefix" {
  default = null
}
variable "node_ami_type" {
  default = "AL2_x86_64"
}
variable "node_capacity_type" {
  default = "ON_DEMAND"
}
variable "node_instance_types" {
  default = "t3a.large"
}
variable "node_disk_size" {
  default = "50"
}
variable "node_desired_size" {
  default = "3"
}
variable "node_max_size" {
  default = "3"
}
variable "node_min_size" {
  default = "1"
}
variable "force_update_version" {
  default = null
}
variable "labels" {
  default = null
}
variable "node_group_version" {}
variable "taints_content" {
  type    = any
  default = {}
}
variable "node_tags" {
  default = null
}