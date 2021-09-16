resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = aws_iam_role.cluster_iam_role.arn

# https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html
  vpc_config {
    subnet_ids              = aws_subnet.nodes_subnet[*].id
    public_access_cidrs     = [var.AllowedSourceIPRange]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.service_cidr
  }

  tags = {
    project = "microsegmentation-lab"
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.demo-cluster-AmazonEKSVPCResourceController,
  ]
}


resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "microseg-demo"
  node_role_arn   = aws_iam_role.node_iam_role.arn
  subnet_ids      = aws_subnet.nodes_subnet[*].id
  instance_types  = [var.vmSize]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  tags = {
    Name    = "microseg-demo-node-group"
    project = "microsegmentation-lab"
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.demo-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.demo-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
