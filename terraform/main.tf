resource "aws_security_group" "web_sg" {
  name        = "devsecops-web-sg"
  description = "Security group for DevSecOps assignment"

  ingress {
    description = "SSH access (INTENTIONALLY INSECURE)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # ❌ intentional vulnerability
  }

  ingress {
    description = "Web app access"
    from_port   = 5000
    to_port     = 5000
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
