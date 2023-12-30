resource "aws_vpc" "Demo-vpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "Public-subnet-az1" {
  vpc_id     = aws_vpc.Demo-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "demo-public-az1"
  }
}
resource "aws_subnet" "private-subnet-az1" {
  vpc_id     = aws_vpc.Demo-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "demo-private-az1"
  }
}

resource "aws_internet_gateway" "Demo-igw" {
  vpc_id = aws_vpc.Demo-vpc.id

  tags = {
    Name = "demo"
  }
}


resource "aws_route_table" "Demo-route-table" {
  vpc_id = aws_vpc.Demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Demo-igw.id
  }
  tags = {
    Name = "Demo-routetable"
  }
}
resource "aws_route_table_association" "pri-rt-association-az1" {
  subnet_id      = aws_subnet.private-subnet-az1.id
  route_table_id = aws_route_table.Demo-route-table.id
}

resource "aws_route_table_association" "pub-rt-association-az1" {
  subnet_id      = aws_subnet.Public-subnet-az1.id
  route_table_id = aws_route_table.Demo-route-table.id
}
