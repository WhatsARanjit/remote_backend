#!/bin/bash

curl -o terraform.zip -L "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip terraform.zip
chmod +x terraform

cat << EOF > ~/.terraformrc
credentials "app.terraform.io" {
  token = "${TFE_TOKEN}"
}
EOF

cat << EOF > workspace.tf
terraform {
  backend "remote" {
    workspaces {
     prefix = "${TRAVIS_REPO_SLUG}-"
    }
  }
}
EOF

./terraform init \
  -backend-config="organization=${TFE_ORG}"
./terraform validate

if [[ $TRAVIS_BRANCH == 'master' ]]
then
  ./terraform workspace select prod
  ./terraform apply -auto-approve
fi
