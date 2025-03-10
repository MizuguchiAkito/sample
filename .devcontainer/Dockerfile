ARG VARIANT=20-bullseye
ARG DockerVersion=27.1.1

FROM mcr.microsoft.com/vscode/devcontainers/typescript-node:1-${VARIANT}

# install terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
  apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get -y upgrade && apt-get -y install terraform

# aws cli v2 のインストール
RUN PLATFORM=$( \
    case $(uname -m) in \
      amd64|x86_64 ) echo "x86_64";; \
      arm64|aarch64 ) echo "aarch64";; \
    esac \
  ) && \
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${PLATFORM}.zip" -o "awscliv2.zip" && \
  unzip -q awscliv2.zip && \
  ./aws/install && \
  rm -rf ./awscliv2.zip ./aws

# Session Manager Pluginのインストール
RUN PLATFORM=$( \
    case $(uname -m) in \
      amd64|x86_64 ) echo "64bit";; \
      arm64|aarch64 ) echo "arm64";; \
    esac \
  ) && \
  curl -fsSL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_${PLATFORM}/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb"; \
  dpkg -i /tmp/session-manager-plugin.deb && \
  rm /tmp/session-manager-plugin.deb

# yqのインストール
RUN PLATFORM=$( \
    case $(uname -m) in \
      amd64|x86_64 ) echo "amd64";; \
      arm64|aarch64 ) echo "arm64";; \
    esac \
  ) && \
  sudo wget "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${PLATFORM}" -O /usr/bin/yq && sudo chmod +x /usr/bin/yq

# install global package
RUN su node -c "npm install -g serverless@3 tsx"

# Tab Completion for npm
RUN npm completion >> /etc/bash_completion.d/npm

# https://code.visualstudio.com/remote/advancedcontainers/persist-bash-history
ARG USERNAME=node
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R $USERNAME /commandhistory \
    && echo "$SNIPPET" >> "/home/$USERNAME/.bashrc"

ENV TF_PLUGIN_CACHE_DIR="/home/$USERNAME/.terraform.d/plugin-cache"
ADD .caches/tf_plugin_1736499315.tar.gz $TF_PLUGIN_CACHE_DIR
