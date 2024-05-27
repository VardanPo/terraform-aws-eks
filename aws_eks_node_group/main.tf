#------------------------EKS-node-----------------------------
resource "aws_eks_node_group" "node_group" {
  cluster_name           = var.cluster_name
  node_group_name        = var.node_name
  node_group_name_prefix = var.node_group_name_prefix
  version                = var.node_group_version
  node_role_arn          = var.node_role_arn
  subnet_ids             = var.subnet_ids
  ami_type               = var.node_ami_type
  capacity_type          = var.node_capacity_type
  instance_types         = [var.node_instance_types]
  disk_size              = var.node_disk_size
  force_update_version   = var.force_update_version
  labels                 = var.labels


  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  dynamic "taint" {
    for_each = var.taints_content == {} ? [] : [var.taints_content]

    content {
      key    = taint.value["key"]
      value  = taint.value["value"]
      effect = taint.value["effect"]
    }
  }

  tags = var.node_tags
}