locals {
  template_runner_config = templatefile("${path.module}/template/template_config.toml",
    {
      runners_name           = var.runners_name
      runners_concurrent     = var.runners_concurrent
      runners_check_interval = var.runners_check_interval
      runners_shm_size       = var.runners_shm_size
    }
  )
  # 参考 https://github.com/npalm/terraform-aws-gitlab-runner
  template_user_data = templatefile("${path.module}/template/userData.sh", {
    runners_config = local.template_runner_config
    token          = var.gitlab_runner_token
    url            = var.runners_gitlab_url
  })
}

resource "aws_instance" "gitlab_runner" {
  ami           = "ami-0ab02459752898a60"
  instance_type = "t3.medium"

  tags = {
    Name = "${var.prefix_name}-dind"
  }

  # Session Manager用
  iam_instance_profile = aws_iam_instance_profile.instance_role.name

  user_data_base64 = base64gzip(local.template_user_data)

  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.gitlab_runner.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = 30
    iops        = 3000
    throughput  = 125
    tags = {
      Name = "${var.prefix_name}-dind-root"
    }
  }
}
