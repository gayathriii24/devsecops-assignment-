resource "aws_security_group" "web_sg" {
  name        = "devsecops-web-sg"
  description = "Secure security group for DevSecOps assignment"

  ingress {
    description = "Allow SSH only from trusted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24"]   # ✅ restricted SSH access
  }

  ingress {
    description = "Allow web application traffic"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
  description = "Allow outbound traffic only to internal network"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["192.168.1.0/24"]   # ✅ restricted egress
}

}
