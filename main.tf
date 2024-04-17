provider "aws" {
  region = "ap-southeast-2"
}
# Create VPC virtual private cloud
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
         Name = "my-vpc"
 }
}
# Create subnet
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
      Name = "my-subnet"
  }
}
# Create internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
        Name = "my-internet-gateway"  
}
}
# creating route table
resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my-rt"
  }
}
# Assosiate subnet with route table
resource "aws_route_table_association" "my-rt-association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_rt.id
}

# Attach internet gateway to VPC
/*resource "aws_vpc_attachment" "my_attachment" {
  vpc_id       = aws_vpc.my_vpc.id
  internet_gateway_id = aws_internet_gateway.my_igw.id
}*/

# Create security group
resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Create EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-09c8d5d747253fb7a"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.my_sg.id]
  tags = {
         Name = "my_instance"
  }
}
