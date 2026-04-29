# 1. Definim providerul de Cloud
provider "aws" {
  region = "eu-central-1" # Frankfurt
}

# 2. Creăm un Firewall (Security Group)
resource "aws_security_group" "sirius_sg" {
  name        = "sirius-orange-sg"
  description = "Security group pentru K3s si Web"

  # Portul 22 pentru Ansible (SSH)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Portul 80 pentru aplicatia noastra web (Trafic Public)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Portul 6443 pentru a putea da comenzi lui Kubernetes
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitem serverului sa iasa pe internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Căutăm automat cea mai recentă imagine de Ubuntu 22.04
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Contul oficial Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 4. Creăm mașina virtuală EC2
resource "aws_instance" "k3s_master" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro" # Rămânem în AWS Free Tier
  
  key_name      = "sirius-key"
  
  vpc_security_group_ids = [aws_security_group.sirius_sg.id]

  tags = {
    Name = "Sirius-Orange-Cluster"
  }
}

# 5. Afișăm IP-ul public la finalul execuției
output "server_ip" {
  value       = aws_instance.k3s_master.public_ip
  description = "Adresa IP a noului tau server"
}