provider "aws" {
  region = "ap-south-1"
}

# -------------------------------
# SECURITY GROUP (SECURE)
# -------------------------------
resource "aws_security_group" "web_sg" {
  name        = "devsecops-web-sg"
  description = "Secure security group for DevSecOps assignment"

  # SSH access (restricted)
  ingress {
    description = "Allow SSH only from trusted IP range"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24"]
  }

  # Application access
  ingress {
    description = "Allow Flask app traffic"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Restricted outbound traffic
  egress {
    description = "Allow outbound HTTPS traffic only"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevSecOps-SG"
  }
}

# -------------------------------
# EC2 INSTANCE (CLOUD DEPLOYMENT)
# -------------------------------
resource "aws_instance" "devsecops_server" {
  ami                    = "ami-0f5ee92e2d63afc18"   # Amazon Linux 2 (Mumbai)
  instance_type          = "t2.micro"
  key_name               = "devsecops-key"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install docker -y
              service docker start
              usermod -aG docker ec2-user
              docker run -d -p 5000:5000 gayathripoojary/flask-app
              EOF

  tags = {
    Name = "DevSecOps-Cloud-Server"
  }
}

# -------------------------------
# OUTPUT PUBLIC IP
# -------------------------------
output "public_ip" {
  description = "Public IP of the DevSecOps EC2 instance"
  value       = aws_instance.devsecops_server.public_ip
}
