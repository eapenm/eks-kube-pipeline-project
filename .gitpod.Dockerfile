FROM gitpod/workspace-full

# install aws-cli v2 and terraform
RUN sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && sudo ./aws/install \
  && sudo apt-get update \
  && sudo apt-get install -y gnupg software-properties-common curl \
  && sudo curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - \
  && sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
  && sudo apt-get install terraform \
  && sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - \
  && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list \
  && sudo apt-get update \
  && sudo apt-get install -y kubectl