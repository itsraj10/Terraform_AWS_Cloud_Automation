# Terraform_Project

Deploying a VPC with Multi-AZ Public Subnets, Internet Gateway, EC2 Instance, Application Load Balancer, DynamoDB and S3 for backend to store terraform state file.

____________________________________________________________________________________________________________________________

📝 Project Summary:

This project demonstrates how to deploy a scalable AWS EC2 instance using Terraform from scratch. It reflects real-world Infrastructure as Code (IaC) principles by provisioning cloud resources automatically and reproducibly. This is ideal for those looking to showcase DevOps automation capabilities and cloud infrastructure provisioning on AWS.
____________________________________________________________________________________________________________________________

Understanding The Components:

![Terraform](https://github.com/user-attachments/assets/ccecdfa3-9b35-4e81-a2a5-5af7a958b5cf)
____________________________________________________________________________________________________________________________

🏗️ Technical Architecture Overview:

* A Virtual Private Cloud (VPC) to logically isolate resources
* Public Subnet for internet-facing EC2 instances
* Internet Gateway to enable internet access
* Route Table for routing external traffic
* A Security Group to allow SSH (port 22) and HTTP (port 80) traffic
* A single EC2 Instance running Amazon Linux, configured to auto-start a simple web server
* An S3 Bucket for storing Terraform state files securely and enabling remote state management
* A DynamoDB Table to enable Terraform state locking and prevent concurrent state modifications

____________________________________________________________________________________________________________________________

🛠️ Technologies Used:

1. Terraform – Infrastructure as Code tool
2. AWS EC2 – Virtual server provisioning
3. AWS VPC, Subnets, IGW, Route Tables – Networking components
4. Amazon Linux 2 – EC2 AMI
5. User Data Script – Bootstraps the instance to install and start the web server
6. SSH – Remote access to EC2
____________________________________________________________________________________________________________________________

📁 Project Structure:

![image](https://github.com/user-attachments/assets/b8be44b1-60c6-4c7e-83d1-1c7181c524ea)

NOTE: Terraform state files are stored in an S3 backend to ensure secure, centralized storage and team collaboration.
____________________________________________________________________________________________________________________________

💻 Tasks Overview:

🔹 Provider & Initialization
   * Defined AWS provider targeting the us-east-1 region.
   * Initialized Terraform workspace using terraform init.

🔹 Networking
   * VPC: Created a custom VPC with a configurable CIDR block.
   * Subnets: Created two public subnets (sub1, sub2) in the same region.
   * Internet Gateway: Attached to the VPC for outbound internet access.
   * Route Table:
     1. Configured route to allow internet traffic (0.0.0.0/0).
     2. Associated with both public subnets.

🔹 Security
   * Security Group (websg):
     1. Allowed inbound traffic on port 22 (SSH), port 80 (HTTP), and port 443 (HTTPS) from all IPs.
     2. Enabled outbound traffic on all ports.

🔹 Compute Resources
   * EC2 Instances:
     1. Deployed two EC2 instances using Amazon Linux 2 AMI.
     2. Placed each instance in a separate public subnet.
     3. Injected user data scripts to automate web server installation (Apache).
     4. Scripts: userdata.sh and userdata1.sh.

🔹 Storage & State Management
   * S3 Bucket:
     1. Created to store Terraform state files for remote management.
   * DynamoDB Table:
     1. Enabled Terraform state locking to prevent concurrent changes.

🔹 Application Load Balancer
   * ALB:
     1. Created an internet-facing Application Load Balancer.
     2. Attached to both subnets and associated with the security group.
   * Target Group:
     1. Configured health checks on root path /.
     2. Registered both EC2 instances as targets.
   * Listener:
     1. Set up a listener on port 80 to forward traffic to the target group.

🔹 Outputs
   * Displayed Load Balancer DNS as output after provisioning.

🔹 Cleanup
   * Destroyed all infrastructure resources using cmd --> terraform destroy

____________________________________________________________________________________________________________________________

✨ Key Features and Benefits:

✅ One-Command Deployment: Spin up complete AWS infrastructure with terraform apply

✅ Modular & Readable: Clean file structure and reusability

✅ Beginner-Friendly: Easy to follow, even for those new to cloud or IaC

✅ Web Server Ready: Instance is ready to serve a basic HTML page on boot

✅ Secure Defaults: Access controlled via security group rules

____________________________________________________________________________________________________________________________

📚 Lessons Learned:

🔸 Hands-on with core AWS networking concepts like subnets, routing, and security groups

🔸 Terraform best practices: separating variables, outputs, and modular code structure

🔸 Automating configuration using user_data for zero-touch server bootstrapping

🔸 State management and the importance of using .tfstate securely

____________________________________________________________________________________________________________________________

🔮 Future Improvements:  

💠 Use Terraform modules for VPC, EC2, and networking

💠 Add remote state management using AWS S3 and DynamoDB

💠 Add multi-environment support (dev, staging, prod)

💠 Integrate with CI/CD pipelines for automated deployments

💠 Add Monitoring & Logging (e.g., CloudWatch)

____________________________________________________________________________________________________________________________

🔴 Conclusion:

This project showcases end-to-end AWS infrastructure automation using Terraform. It highlights VPC setup, EC2 provisioning, ALB configuration, and best practices like remote state management with S3 and DynamoDB. This project follows Infrastructure as Code (IaC) best practices, offering a clean and production-ready example of automated cloud provisioning.

____________________________________________________________________________________________________________________________
