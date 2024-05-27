## Terraform Module Documentation: AWS EKS Node Group

The AWS EKS Node Group module is a Terraform module that creates an Amazon EKS managed node group.

### Usage

module "eks_node_group" {

  source       = "path/to/module"
  cluster_name = var.cluster_name
  node_role_arn = var.node_role_arn
  subnet_ids = var.subnet_ids

  // Optional variables
  node_name              = var.node_name
  node_group_name_prefix = var.node_group_name_prefix
  node_ami_type          = var.node_ami_type
  node_capacity_type     = var.node_capacity_type
  node_instance_types    = var.node_instance_types
  node_disk_size         = var.node_disk_size
  node_desired_size      = var.node_desired_size
  node_max_size          = var.node_max_size
  node_min_size          = var.node_min_size
  force_update_version   = var.force_update_version
  labels                 = var.labels
  node_group_version     = var.node_group_version
  taints_content         = var.taints_content
  node_tags              = var.node_tags
}

### Required Inputs

* `cluster_name` - The name of the Amazon EKS cluster to create the node group in.
* `node_role_arn` - The ARN of the IAM role that provides permissions for the Amazon EKS worker nodes to communicate with the Amazon EKS API server.
* `subnet_ids` - The IDs of the subnets to launch the Amazon EKS worker nodes in.

### Optional Inputs

* `node_name` - A name for the Amazon EKS node group. If not set, Terraform will generate a random name for the node group.
* `node_group_name_prefix` - A prefix to add to the generated node group name.
* `node_ami_type` - The AMI type for the Amazon EKS worker nodes. Defaults to `AL2_x86_64`.
* `node_capacity_type` - The capacity type for the Amazon EKS worker nodes. Defaults to `ON_DEMAND`.
* `node_instance_types` - A list of instance types for the Amazon EKS worker nodes. Defaults to `["t3a.large"]`.
* `node_disk_size` - The size of the Amazon EBS volumes for the Amazon EKS worker nodes. Defaults to `50`.
* `node_desired_size` - The desired number of Amazon EKS worker nodes in the node group. Defaults to `3`.
* `node_max_size` - The maximum number of Amazon EKS worker nodes in the node group. Defaults to `3`.
* `node_min_size` - The minimum number of Amazon EKS worker nodes in the node group. Defaults to `1`.
* `force_update_version` - Force version update if True.
* `labels` - Key-value map of labels to add to the Amazon EKS node group.
* `node_group_version` - The Kubernetes version for the Amazon EKS worker nodes.
* `taints_content` - A map containing the taints to apply to the Amazon EKS worker nodes.
* `node_tags` - Key-value map of tags to add to the Amazon EKS node group.

### Outputs

* `id` - The ID of the created Amazon EKS node group.
* `arn` - The ARN of the created Amazon EKS node group.
* `labels` - The labels associated with the created Amazon EKS node group.
