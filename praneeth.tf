provider "aws" {
    profile = "praneeth"
    region = "ap-south-1" 
}

data "aws_key_pair" "prankey" {
  key_name = "Test" # Replace with the name of your existing key pair
}

resource "aws_vpc" "pranvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "pranvpctag"
  }
}

resource "aws_internet_gateway" "pran_igw" {
  vpc_id = aws_vpc.pranvpc.id

  tags = {
    Name = "pran_internet_gateway"
  }
}

resource "aws_route_table" "pran_route_table" {
  vpc_id = aws_vpc.pranvpc.id

  tags = {
    Name = "pran_route_table"
  }
}


resource "aws_route" "my_route" {
  route_table_id         = aws_route_table.pran_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.pran_igw.id
}


resource "aws_subnet" "pransubnet" {
  vpc_id            = aws_vpc.pranvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "pransubnettag"
  }
}


resource "aws_route_table_association" "pran_route_table_association" {
  subnet_id      = aws_subnet.pransubnet.id
  route_table_id = aws_route_table.pran_route_table.id
}

resource "aws_security_group" "pransg" {
  vpc_id = aws_vpc.pranvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["142.250.183.100/32"]
  }

  tags = {
    Name = "pransgtag"
  }
}

resource "aws_instance" "pranvm" {
  count         = 2  
  ami           = "ami-053b12d3152c0cc71"
  instance_type = "t2.micro"
  key_name = data.aws_key_pair.prankey.key_name
  subnet_id     = aws_subnet.pransubnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.pransg.id]

  tags = {
    Name = "pranvmtag-${count.index + 1}"
  }
}


output "instance_public_ips" {
  value = aws_instance.pranvm.*.public_ip
}

output "instance_ids" {
  value = aws_instance.pranvm.*.id
}
