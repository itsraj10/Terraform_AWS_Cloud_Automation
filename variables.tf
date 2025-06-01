variable "cidr" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "ami_id" {
    description = "AMI ID for the EC2 instance"
    type        = string
    default     = "ami-0261755bbcb8c4a84"
  
}

variable "instance_type" {
    description = "Instance type for the EC2 instance"
    type        = string
    default     = "t2.micro"
  
}

variable "lb" {
    description = "Name of the Application Load Balancer"
    type        = string
    default     = "application"
  
}

variable "aws_s3_bucket_name" {
    description = "Name of the S3 bucket"
    type        = string
    default     = "terraformbucketstatefile942464"
  
}

variable "aws_region1" {
    description = "AWS region for the resources"
    type        = string
    default     = "us-east-1a"
}

variable "aws_region2" {
    description = "AWS region for the resources"
    type        = string
    default     = "us-east-1b"
}
