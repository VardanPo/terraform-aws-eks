# ------------------------------ Data ------------------------------
data "aws_partition" "current" {}

# ------------------------------ EKS cluster ------------------------------
locals {
  cluster_role                     = try(aws_iam_role.cluster_role[0].arn, var.cluster_role_arn)
  enable_cluster_encryption_config = length(var.cluster_encryption_config) > 0
}

resource "aws_eks_cluster" "eks_cluster" {
  count = var.create_cluster ? 1 : 0

  name                      = var.cluster_name
  role_arn                  = local.cluster_role
  version                   = var.cluster_version
  enabled_cluster_log_types = var.cluster_enabled_log_types

  vpc_config {
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_public_access_cidrs
    security_group_ids      = compact(distinct(concat(var.cluster_additional_security_group_ids, [local.cluster_security_group_id])))
    subnet_ids              = compact(distinct(var.subnet_ids))
  }

  kubernetes_network_config {
    ip_family         = var.cluster_ip_family
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
    service_ipv6_cidr = var.cluster_service_ipv6_cidr
  }

  dynamic "encryption_config" {
    for_each = local.enable_cluster_encryption_config ? [var.cluster_encryption_config] : []

    content {
      provider {
        key_arn = var.create_kms_key ? module.kms.key_arn : encryption_config.value.provider_key_arn
      }
      resources = encryption_config.value.resources
    }
  }

  tags = merge(
    var.tags,
    var.cluster_tags,
  )

}

# ------------------------------ IAM Role ------------------------------
locals {
  create_iam_role        = var.create_cluster && var.create_iam_role
  iam_role_name          = coalesce(var.iam_role_name, "${var.cluster_name}-cluster")
  dns_suffix             = coalesce(var.cluster_iam_role_dns_suffix, data.aws_partition.current.dns_suffix)
  iam_role_policy_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"

}

data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create_cluster && var.create_iam_role ? 1 : 0

  statement {
    sid     = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.${local.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "cluster_role" {
  count = local.create_iam_role ? 1 : 0

  name        = var.iam_role_use_name_prefix ? null : local.iam_role_name
  name_prefix = var.iam_role_use_name_prefix ? "${local.iam_role_name}-" : null
  path        = var.iam_role_path
  description = var.iam_role_description

  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy[0].json
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = true

  dynamic "inline_policy" {
    for_each = var.create_cloudwatch_log_group ? [1] : []
    content {
      name = local.iam_role_name

      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action   = ["logs:CreateLogGroup"]
            Effect   = "Deny"
            Resource = "*"
          },
        ]
      })
    }
  }

  tags = merge(var.tags, var.iam_role_tags)
}

resource "aws_iam_role_policy_attachment" "role_policy" {
  for_each = { for k, v in {
    AmazonEKSClusterPolicy         = "${local.iam_role_policy_prefix}/AmazonEKSClusterPolicy",
    AmazonEKSVPCResourceController = "${local.iam_role_policy_prefix}/AmazonEKSVPCResourceController",
  } : k => v if local.create_iam_role }

  policy_arn = each.value
  role       = aws_iam_role.cluster_role[0].name
}

resource "aws_iam_role_policy_attachment" "additional_role_policy" {
  for_each = { for k, v in var.iam_role_additional_policies : k => v if local.create_iam_role }

  policy_arn = each.value
  role       = aws_iam_role.cluster_role[0].name
}

resource "aws_iam_role_policy_attachment" "encryption" {
  count = local.create_iam_role && var.attach_cluster_encryption_policy && local.enable_cluster_encryption_config ? 1 : 0

  policy_arn = aws_iam_policy.cluster_encryption[0].arn
  role       = aws_iam_role.this[0].name
}

# ------------------------------ Cluster Security Group ------------------------------
locals {
  create_cluster_sg         = var.create_cluster && var.create_cluster_security_group
  cluster_security_group_id = local.create_cluster_sg ? aws_security_group.cluster_sg[0].id : var.cluster_security_group_id

}