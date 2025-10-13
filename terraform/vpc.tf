data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_vpc" "mains" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = merge(var.tags, { Name = "main_vpc" })
}

# subnet reation 

resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.mains.id
    cidr_block = cidrsubnet(var.cidr_block, 8, 10)
    availability_zone = data.aws_availability_zones.available.names[0]
    # tags = merge(var.tags, { Name = "subnet-a" })
    tags=var.tags
}
resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.mains.id
    cidr_block = cidrsubnet(var.cidr_block, 8, 20)
    availability_zone = data.aws_availability_zones.available.names[1]
    #tags = merge(var.tags, { Name = "subnet-b" })
    tags=var.tags
}

resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.mains.id
    cidr_block = cidrsubnet(var.cidr_block, 8, 110)
    availability_zone = data.aws_availability_zones.available.names[0]
    # tags = merge(var.tags, { Name = "subnet-c" })
    tags=var.tags
}
resource "aws_subnet" "private_subnet_2" {
    vpc_id = aws_vpc.mains.id
    cidr_block = cidrsubnet(var.cidr_block, 8, 120)
    availability_zone = data.aws_availability_zones.available.names[1]
    tags=var.tags
}

#internetgatewat 

resource "aws_internet_gateway" "eks-igw" {
    vpc_id = aws_vpc.mains.id
    tags=var.tags
}

# eip 
resource "aws_eip" "eks_ngw_eip" {
  domain     = "vpc"
  tags       = var.tags
  depends_on = [aws_internet_gateway.eks-igw]
}
#nat gateway

resource "aws_nat_gateway" "eks_ngw" {
  allocation_id = aws_eip.eks_ngw_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags          = var.tags
  depends_on    = [aws_internet_gateway.eks-igw]
}


# route table
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.mains.id

route {  
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-igw.id
}
tags=var.tags
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.mains.id
    route {  
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.eks_ngw.id
    }
    tags = var.tags
}

# Associate Route Tables with Subnets
resource "aws_route_table_association" "public_rt-assoc-1" {
subnet_id      = aws_subnet.public_subnet_1.id
route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt-assoc-2" {
subnet_id      = aws_subnet.public_subnet_2.id
route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt-assoc-1" {
subnet_id      = aws_subnet.private_subnet_1.id
route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt-assoc-2" {
subnet_id      = aws_subnet.private_subnet_2.id
route_table_id = aws_route_table.private_rt.id
}