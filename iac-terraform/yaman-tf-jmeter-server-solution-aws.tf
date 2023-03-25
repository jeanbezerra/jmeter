terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region = "sa-east-1"
  #access_key = "my-access-key"
  #secret_key = "my-secret-key"
}

resource "aws_instance" "yaman-tf-aws-linux-jmeter-node" {
  count         = 20
  # Parameters - Required
  ami           = "ami-0cd88166878525f29"
  instance_type = "t3.2xlarge"
  key_name      = "terraform-apm-aws"
  hibernation = false
  associate_public_ip_address = true
  //vpc_security_group_ids = [ "${aws_security_group.yaman-tf-aws-linux-jmeter-node-sg.id}" ]
  vpc_security_group_ids = [ "yaman-tf-aws-linux-jmeter-node-sg" ]

  # Parameters - Optional
  ebs_optimized = true
  instance_initiated_shutdown_behavior = "stop"
  monitoring = false

  # Tags
  tags = {
    Name = "yaman-tf-aws-linux-jmeter-node-${count.index}"
    Enterprise = "Yaman Tecnologia LTDA"
    YamanCostCenter = "2004 - APM"
    Project = "Porto Seguro"
    Environment = "Production"
    ServiceType = "Stress Test"
    Owner = "jean.bezerra@yaman.com.br"
    Approver = "jean.bezerra@yaman.com.br"
    Terraform = true
  }
  # Thresholds
  timeouts {
    create = "10m"
    delete = "45m"
  }
}

resource "aws_security_group" "yaman-tf-aws-linux-jmeter-node-sg" {
  name        = "yaman-tf-aws-linux-jmeter-node-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-dc00c6b8"

  # Entradas do Firewall
  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH from VPC - JMeter"
    from_port        = 2000
    to_port          = 2000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH from VPC - JMeter"
    from_port        = 5000
    to_port          = 5000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Zabbix Agent In"
    from_port        = 10050
    to_port          = 10050
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Grafana In"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Grafana In"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   ingress {
    description      = "Grafana In"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Influx In (TCP)"
    from_port        = 8086
    to_port          = 8086
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "Influx In (UDP)"
    from_port        = 8086
    to_port          = 8086
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Influx Cronograf In (TCP)"
    from_port        = 8888
    to_port          = 8888
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "Influx Cronograf In (UDP)"
    from_port        = 8888
    to_port          = 8888
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Zabbix Agent Out"
    from_port        = 10051
    to_port          = 10051
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }  

  # Saidas do Firewall
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Tags
  tags = {
    Name = "yaman-tf-aws-linux-jmeter-node-sg"
    Enterprise = "Yaman Tecnologia LTDA"
    YamanCostCenter = "2004 - APM"
    Project = "Porto Seguro"
    Environment = "Production"
    ServiceType = "Stress Test"    
    Owner = "jean.bezerra@yaman.com.br"
    Approver = "jean.bezerra@yaman.com.br"
    Terraform = true
  }
  # Thresholds
  timeouts {
    create = "10m"
    delete = "45m"
  }  
}
