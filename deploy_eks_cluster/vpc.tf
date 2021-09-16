data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = var.vpc_name
    project = "microsegmentation-lab"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "nodes_subnet" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, (count.index+10))
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name                                        = "K8s-Nodes-Subnets"
    project                                     = "microsegmentation-lab"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }
}

resource "aws_route_table" "nodes_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "Nodes_RT"
    project = "microsegmentation-lab"
  }
}


resource "aws_route_table_association" "nodes_rt_association" {
  count          = 2

  subnet_id      = aws_subnet.nodes_subnet.*.id[count.index]
  route_table_id = aws_route_table.nodes_rt.id
}


resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.vpc_name}-igw"
    project = "microsegmentation-lab"
  }
}


resource "aws_route" "nodes_rt_default_route" {
  route_table_id         = aws_route_table.nodes_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_igw.id
}
