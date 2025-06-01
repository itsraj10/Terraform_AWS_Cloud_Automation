# Create a VPC
resource "aws_vpc" "vpc" {
    cidr_block = var.cidr
}

# Create a Subnet1
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = var.aws_region1
  map_public_ip_on_launch = true
}

# Create a Subnet2
resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.aws_region2
  map_public_ip_on_launch = true
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "IG"
  }
}

# Create a Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id

  }   
}
# Associate the Route Table with Subnet1
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_table.id
  
}

# Associate the Route Table with Subnet2
resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.route_table.id
  
}

# Create a Security Group
resource "aws_security_group" "sg" {
  name   = "web-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }
 ingress {
    description = "HTTPs from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }
 ingress {
    description = "SSH"
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

  tags = {
    Name = "Web-sg"
  }

}

# Creating instance1
resource "aws_instance" "web_server1" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  subnet_id               = aws_subnet.subnet1.id
  vpc_security_group_ids  = [aws_security_group.sg.id]
  user_data               = base64encode(file("userdata.sh"))

  tags = {
    Name = "WebServer1"
  }
}

# Creating instance2
resource "aws_instance" "web_server2" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  subnet_id               = aws_subnet.subnet2.id
  vpc_security_group_ids  = [aws_security_group.sg.id]
  user_data              = base64encode(file("userdata1.sh"))

  tags = {
    Name = "WebServer2"
  }
}

# Creating Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = var.lb
 
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  tags = {
    Name = "AppLB"
  }
}

# Creating Target Group
resource "aws_lb_target_group" "example" {
  name = "lb-tg"

  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

# Creating Target Group Attachment for instance1
resource "aws_lb_target_group_attachment" "tg_attach1" {
  target_group_arn = aws_lb_target_group.example.arn
  target_id        = aws_instance.web_server1.id
  port             = 80
}
# Creating Target Group Attachment for instance2
resource "aws_lb_target_group_attachment" "tg_attach2" {
  target_group_arn = aws_lb_target_group.example.arn
  target_id        = aws_instance.web_server2.id
  port             = 80
}

# Creating Load Balancer Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

# Load Balancer DNS name output
output "LoadBalancerDNS" {
  value = aws_lb.app_lb.dns_name
  description = "The DNS name of the Application Load Balancer"
  
}

#create a s3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.aws_s3_bucket_name
}

# Create Dynamodb table
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "Dynomodb-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Lockid"

  attribute {
    name = "Lockid"
    type = "S"
  }
}

