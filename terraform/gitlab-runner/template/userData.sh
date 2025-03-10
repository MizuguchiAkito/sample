#!/bin/bash
set -euX

# 参考 https://github.com/npalm/terraform-aws-gitlab-runner

yum -y update

yum install -y docker
usermod -a -G docker ec2-user
systemctl enable docker
systemctl start docker

curl --fail --retry 6 -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | bash
yum install gitlab-runner -y

# runner configをtemplateに沿って作成
mkdir -p /home/gitlab-runner
cat > /home/gitlab-runner/template-config.toml <<- EOF

${runners_config}

EOF

gitlab-runner register \
  --non-interactive \
  --url ${url} \
  --token ${token} \
  --docker-image docker:24.0.5 \
  --executor docker \
  --template-config /home/gitlab-runner/template-config.toml

usermod -a -G docker gitlab-runner

service gitlab-runner restart
