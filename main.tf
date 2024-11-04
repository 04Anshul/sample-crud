provider "aws" {
  region = "ap-south-1"
  access_key = ""
  secret_key = ""
}

resource "aws_instance" "terra-server" {
    ami = ""
    instance_type = "t2.micro"
    key_name = "test-key"
    vpc_security_group_ids = [aws_security_group.my-sg.id]
    subnet_id = aws_subnet.public-subnet-1.id
    for_each = toset(["server-1", "server-2", "server-3", "server-4"])
    tags = {
     Name = "${each.key}"
    }
}

resource "aws_security_group" "my-sg" {
  name        = "my-sg"
  description = "SSH Access"
  vpc_id = aws_vpc.new-vpc.id 
  
  ingress {
    description      = "Ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-protocol"

  }
}

resource "aws_vpc" "new-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "new-vpc"
  }
  
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.new-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.new-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "private-subnet-2"
  }
}
resource "aws_subnet" "private-subnet-3" {
  vpc_id     = aws_vpc.new-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-south-1c"
  tags = {
    Name = "private-subnet-3"
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.new-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.new-vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public-subnet-2"
  }
}
resource "aws_subnet" "public-subnet-3" {
  vpc_id     = aws_vpc.new-vpc.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "ap-south-1c"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public-subnet-3"
  }
}


resource "aws_internet_gateway" "new-igw" {
  vpc_id = aws_vpc.new-vpc.id 
  tags = {
    Name = "new-igw"
  } 
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.new-vpc.id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.new-igw.id 
  }
}

resource "aws_route_table_association" "rta-public-subnet-01" {
  subnet_id = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-rt.id   
}

resource "aws_route_table_association" "rta-public-subnet-02" {
  subnet_id = aws_subnet.public-subnet-2.id 
  route_table_id = aws_route_table.public-rt.id   
}
resource "aws_route_table_association" "rta-public-subnet-03" {
  subnet_id = aws_subnet.public-subnet-3.id 
  route_table_id = aws_route_table.public-rt.id   
}