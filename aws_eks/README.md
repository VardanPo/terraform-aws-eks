## Terraform Module Documentation: AWS EKS Cluster with Add-ons

### Module Overview

This Terraform module creates an AWS EKS (Elastic Kubernetes Service) cluster with addons. The module creates the EKS cluster, configures VPC, subnets, security groups, and other EKS-related resources. It also installs specified addons like "kube-proxy", "vpc-cni", "aws-node", etc. The module is flexible enough to support customization of various EKS parameters, such as EKS version, endpoint access, encryption, logging, and more.

### Usage

module "eks_cluster" {

  source = "path/to/module"

  eks_name           = "my-eks-cluster"
  eks_version        = "1.21"
  role_arn           = aws_iam_role.eks_cluster.arn
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.vpc_default_sg_id]
  cluster_tags       = {
    Name = "My EKS Cluster"
  }

  addons_data = {
    kube-proxy = {
      addon_name        = "kube-proxy"
      addon_version     = "v1.21.2-eks-1"
      resolve_conflicts = "OVERWRITE"
    }
    aws-node = {
      addon_name        = "aws-node"
      addon_version     = "v1.21.2-eks-1"
      resolve_conflicts = "OVERWRITE"
    }
  }

  addon_tags = {
    Environment = "dev"
  }
}

### Variables

* `eks_name`: The name of the EKS cluster to create.
* `eks_version`: The version of Kubernetes to use in the EKS cluster. Defaults to `null`.
* `role_arn`: The Amazon Resource Name (ARN) of the IAM role to use for the EKS cluster.
* `endpoint_private_access`: Whether or not the EKS cluster should have private access to the Kubernetes API server endpoint. Defaults to `false`.
* `endpoint_public_access`: Whether or not the EKS cluster should have public access to the Kubernetes API server endpoint. Defaults to `true`.
* `public_access_cidrs`: A list of CIDR blocks that are allowed public access to the Kubernetes API server endpoint. Defaults to `["0.0.0.0/0"]`.
* `security_group_ids`: A list of security group IDs for the EKS cluster. Defaults to `[]`.
* `subnet_ids`: A list of subnet IDs for the EKS cluster.
* `enabled_cluster_log_types`: A list of the types of logs to enable for the EKS cluster. Defaults to `[]`.
* `key_arn`: The ARN of the KMS key to use for encryption configuration. Defaults to `""`.
* `resources`: A list of resources to encrypt with the KMS key. Defaults to `[""]`.
* `ip_family`: The IP address family for the Kubernetes service network. Defaults to `"ipv4"`.
* `service_ipv4_cidr`: The CIDR block for the Kubernetes service network. Defaults to `"172.20.0.0/16"`.
* `cluster_tags`: A map of tags to apply to the EKS cluster. Defaults to `null`.
* `addons_data`: A map of data for the EKS cluster add-ons.
* `addon_tags`: A map of tags to apply to the EKS cluster add-ons. Defaults to `null`.

### Outputs

* `name`: The name of the EKS cluster.
* `id`: The ID of the EKS cluster.
* `arn`: The ARN of the EKS cluster.
* `version`: The version of Kubernetes used in the EKS cluster.
