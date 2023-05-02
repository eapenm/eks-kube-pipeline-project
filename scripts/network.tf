resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  tags = merge(
    local.common_tags,
    tomap({
    Name = "${local.prefix}-vpc"
  })
  )
}

resource "aws_subnet" "private1" {
  #count = 2

  #cidr_block = "10.0.${count.index + 1}.0/24"
  cidr_block = "10.0.2.0/24"
  vpc_id                  = aws_vpc.main.id
   availability_zone = "${var.region}b"
}
resource "aws_subnet" "private2" {
  #count = 2

  #cidr_block = "10.0.${count.index + 1}.0/24"
  cidr_block = "10.0.1.0/24"
  vpc_id                  = aws_vpc.main.id
   availability_zone = "${var.region}a"
}


resource "aws_security_group" "worker_group" {
  name_prefix = "worker_group_"
  vpc_id      = aws_vpc.main.id
}


resource "aws_iam_role" "worker_group" {
  name = "worker_group"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "worker_group" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker_group.name
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker_group.name
}