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

