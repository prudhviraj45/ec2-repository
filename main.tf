## Creating a VPC
resource "aws_vpc" "Main" {                
  ## Defining the CIDR block use 10.0.0.0/24 for demo
  cidr_block       = var.main_vpc_cidr     
  instance_tenancy = "default"
}

## Creating Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "IGW" {   
   # vpc_id will be generated after we create VPC 
   vpc_id =  aws_vpc.Main.id               
}

## Creating a Public Subnet
resource "aws_subnet" "publicsubnets" {    
  vpc_id =  aws_vpc.Main.id
  # CIDR block of public subnets
  cidr_block = var.public_subnets          
}

## Creating Route Table for Public Subnet
resource "aws_route_table" "PublicRT" {    
   vpc_id =  aws_vpc.Main.id
   route {
     cidr_block = "0.0.0.0/0"               
     ## Traffic from Public Subnet reaches Internet via Internet Gateway
     gateway_id = aws_internet_gateway.IGW.id
    }
}

## Route table association with Public Subnet
resource "aws_route_table_association" "PublicRTassociation" {
   subnet_id = aws_subnet.publicsubnets.id
   route_table_id = aws_route_table.PublicRT.id
}
  
## Creating the EC2 instance based on the ami and instance_type
resource "aws_instance" "my-machine" {
  ami = var.ami 
  instance_type = var.instance_type 
  subnet_id     = aws_subnet.publicsubnets.id
  tags = {
    Name = "my-ec2-machine"
  }
}
