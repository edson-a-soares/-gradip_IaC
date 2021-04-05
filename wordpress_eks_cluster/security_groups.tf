resource "aws_security_group" "alb_security_group" {

  name   = "${var.project_name}-${var.environment_name}-alb"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group_rule" "alb_security_group_ecs_instance_egress" {

  from_port                = 0
  protocol                 = "tcp"
  to_port                  = 65535
  type                     = "egress"
  security_group_id        = aws_security_group.alb_security_group.id
  source_security_group_id = aws_security_group.http_security_group.id

}

resource "aws_security_group" "http_security_group" {

  vpc_id  = data.aws_vpc.default.id
  name    = "${var.project_name}-${var.environment_name}-http"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    security_groups = [ aws_security_group.alb_security_group.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "database_security_group" {

  vpc_id  = data.aws_vpc.default.id
  name    = "${var.project_name}-${var.environment_name}-rds"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group_rule" "ecs_instance_rds_egress" {
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  type                     = "egress"
  security_group_id        = aws_security_group.http_security_group.id
  source_security_group_id = aws_security_group.database_security_group.id
}


#-------------------------------------------------------------------------
# Cluster
#-------------------------------------------------------------------------
resource "aws_security_group" "wordpress_eks_cluster" {

  name        = "wordpress-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

//resource "aws_security_group_rule" "eks_cluster_ingress_workstation_https" {
//
//  cidr_blocks = ["0.0.0.0/0"]
//  description       = "Allow workstation to communicate with the cluster API Server."
//  security_group_id = aws_security_group.wordpress_eks_cluster.id
//  from_port         = 443
//  protocol          = "tcp"
//  to_port           = 443
//  type              = "ingress"
//
//}


#-------------------------------------------------------------------------
# Cluster
#-------------------------------------------------------------------------
resource "aws_security_group" "wordpress_eks_cluster_nodes" {

  name        = "wordpress-eks-cluster-nodes"
  description = "Security group for all nodes in the cluster"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group_rule" "wordpress_eks_cluster_ingress_self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.wordpress_eks_cluster_nodes.id
  source_security_group_id = aws_security_group.wordpress_eks_cluster_nodes.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "wordpress_eks_cluster_ingress_cluster_https" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.wordpress_eks_cluster.id
  security_group_id        = aws_security_group.wordpress_eks_cluster_nodes.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "wordpress_eks_cluster_ingress_cluster_others" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.wordpress_eks_cluster.id
  security_group_id        = aws_security_group.wordpress_eks_cluster_nodes.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "wordpress_eks_cluster_ingress_node_https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.wordpress_eks_cluster.id
  source_security_group_id = aws_security_group.wordpress_eks_cluster_nodes.id
  to_port                  = 443
  type                     = "ingress"
}
