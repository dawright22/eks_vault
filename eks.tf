#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_iam_role" "terraform-multi-cloud-k8-demo-cluster" {
  name = "terraform-multi-cloud-k8-demo-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "terraform-multi-cloud-k8-demo-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.terraform-multi-cloud-k8-demo-cluster.name
}

resource "aws_iam_role_policy_attachment" "terraform-multi-cloud-k8-demo-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.terraform-multi-cloud-k8-demo-cluster.name
}

resource "aws_security_group" "terraform-multi-cloud-k8-demo-cluster" {
  name        = "terraform-multi-cloud-k8-demo-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.multi-cloud-k8-demo.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-demo"
  }
}

resource "aws_security_group_rule" "demo-cluster-ingress" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all to communicate with the cluster API Server"
  from_port         = 0
  protocol          = "tcp"
  security_group_id = aws_security_group.terraform-multi-cloud-k8-demo-cluster.id
  to_port           = 0
  type              = "ingress"
}


resource "aws_eks_cluster" "demo" {
  name     = "${random_pet.name.id}-eks"
  role_arn = aws_iam_role.terraform-multi-cloud-k8-demo-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.terraform-multi-cloud-k8-demo-cluster.id]
    subnet_ids         = aws_subnet.multi-cloud-k8-demo[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.terraform-multi-cloud-k8-demo-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.terraform-multi-cloud-k8-demo-cluster-AmazonEKSServicePolicy,
  ]

}

# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "terraform-multi-cloud-k8-demo-node" {
  name = "terraform-multi-cloud-k8-demoo-node"

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

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.terraform-multi-cloud-k8-demo-node.name
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.terraform-multi-cloud-k8-demo-node.name
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.terraform-multi-cloud-k8-demo-node.name
}

resource "aws_eks_node_group" "demo" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "demo"
  node_role_arn   = aws_iam_role.terraform-multi-cloud-k8-demo-node.arn
  subnet_ids      = aws_subnet.multi-cloud-k8-demo[*].id

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.demo-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.demo-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

