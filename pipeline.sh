#!/bin/bash

curl -o terraform.zip -L "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip terraform.zip
chmod +x terraform

cat << EOF > ~/.terraformrc
credentials "app.terraform.io" {
  token = "${TFE_TOKEN}"
}
EOF

WORKSPACE_NAME=$(echo $TRAVIS_REPO_SLUG | sed 's%/%-%g')
cat << EOF > workspace.tf
terraform {
  backend "remote" {
    organization = "${TFE_ORG}"
    workspaces {
     prefix = "${WORKSPACE_NAME}-"
    }
  }
}
EOF

# Init fails because there is no default workspace yet
./terraform init || true


# Create workspace if it doesn't exist
./terraform workspace select $TRAVIS_BRANCH || \
./terraform workspace new $TRAVIS_BRANCH

# Plan
./terraform plan || exit 1

# Apply only on master
if [[ $TRAVIS_BRANCH == 'master' ]]
then
  ./terraform apply -auto-approve || exit 1
fi
