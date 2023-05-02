resource "aws_eks_cluster" "system_monitoring_app" {
  name     = "system_monitoring_app"
  role_arn = aws_iam_role.eks.arn

 # vpc_config {
  #  subnet_ids = aws_subnet.private.*.id
  #}
    vpc_config {
    subnet_ids = [
      aws_subnet.private1.id,
      aws_subnet.private2.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks,
  ]
}

resource "aws_iam_role" "eks" {
  name = "system-monitoring-app-eks"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_eks_node_group" "worker_group" {
  cluster_name    = aws_eks_cluster.system_monitoring_app.id
  node_group_name = "worker_groups"
  node_role_arn   = aws_iam_role.worker_group.arn
  subnet_ids = [
      aws_subnet.private1.id,
      aws_subnet.private2.id
    ]

  instance_types = [
    "t2.micro"
  ]

  ami_type = "AL2_x86_64"
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  depends_on = [
    aws_iam_role_policy_attachment.worker_group,
  ]
}