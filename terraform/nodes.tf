resource "aws_iam_role" "eksterraformcluster-node" {
  name = "eksterraformcluster-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eksterraformcluster-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eksterraformcluster-node.name
}

resource "aws_iam_role_policy_attachment" "eksterraformcluster-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eksterraformcluster-node.name
}

resource "aws_iam_role_policy_attachment" "eksterraformcluster-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eksterraformcluster-node.name
}

resource "aws_eks_node_group" "eksterraformclusterng" {
  cluster_name    = aws_eks_cluster.eksterraformcluster.name
  node_group_name = "eksterraformclusterng"
  node_role_arn   = aws_iam_role.eksterraformcluster-node.arn
  subnet_ids      = aws_subnet.ekssubnet[*].id

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eksterraformcluster-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eksterraformcluster-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eksterraformcluster-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}