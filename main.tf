
resource "aws_instance" "gitlab" {
  ami           = "ami-0a8b4cd432b1c3063"
  instance_type = "t3.large"
  #subnet_id = ""
  vpc_security_group_ids      = [module.security_group.security_group_id]
  # Can also be set to false however vpn access would be required
  associate_public_ip_address = "true"
  key_name                    = "gitlab-poc"
  user_data     = <<-EOF
                  #!/bin/bash
                  curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash;
                  yum install gitlab-ce -y
                  EOF
}

resource "aws_instance" "runner1" {
  ami           = "ami-0a8b4cd432b1c3063"
  instance_type = "t3.small"
  #subnet_id = ""
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = "false"
  key_name                    = "gitlab-poc"
  user_data     = <<-EOF
                  #!/bin/bash
                  curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh" | sudo bash;
                  sudo yum install gitlab-runner -y
                  EOF
}

resource "aws_instance" "runner2" {
  ami           = "ami-0a8b4cd432b1c3063"
  instance_type = "t3.small"
  #subnet_id = ""
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = "false"
  key_name                    = "gitlab-poc"
  user_data     = <<-EOF
                  #!/bin/bash
                  curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh" | sudo bash;
                  sudo yum install gitlab-runner -y
                  EOF
}


module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"

  name        = local.name_sg
  description = "Security group ${local.product} EC2s"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "port 22 for ssh access to internet"
      # (bad practice)
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "port 80 for http access to internet"
      # (only if you want to publicly host)
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "port 443 for http access to internet"
      # (only if you want to publicly host)
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]
}


locals {
  name_sg = "gitlab-poc"
  product = "gitlab-poc"

}