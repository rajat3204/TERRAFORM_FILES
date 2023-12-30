resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa-4096.public_key_openssh
}
resource "local_file" "private_key" {
    content = tls_private_key.rsa-4096.private_key_pem
    filename = var.key_name
    
}
resource "aws_security_group" "new-sg" {
  name        = "terraform-sg"
  description = "Example security group for AWS"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere
  }
   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}
resource "aws_instance" "nginx-instance" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_pair.key_name
  subnet_id     = "subnet-0208569732f684cd8"
  vpc_security_group_ids = [ aws_security_group.new-sg.id ]


  tags = {
    Name = "nginx"
  }
}

resource "aws_instance" "jenkins-instance" {
  ami           = "ami-023c11a32b0207432"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_pair.key_name
  subnet_id     = "subnet-0208569732f684cd8"
  vpc_security_group_ids = [ aws_security_group.new-sg.id ]
 

  tags = {
    Name = "jenkins"
  }
}
