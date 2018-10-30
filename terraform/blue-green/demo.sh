#!/usr/bin/env bash

set -e

TF_WORKSPACE=blue-green
DOCKER_TAG=v1

read  -n 1 -p "Apply TF in commons - deployment_step=create_green ?" mainmenuinput
cd commons
terraform init -get -reconfigure
terraform workspace select ${TF_WORKSPACE}
terraform apply -var deployment_step=create_green -auto-approve
GREEN_ENV=$(terraform output green_env)
GREEN_ENDPOINT=http://$(terraform output green-service-endpoint)
cd -

read  -n 1 -p "Apply TF in guestbook-datastore ?" mainmenuinput
cd guestbook-datastore
terraform init -get -reconfigure
terraform workspace select ${TF_WORKSPACE}
terraform apply -auto-approve
cd -


read  -n 1 -p "Apply TF in guestbook-service/workspace: ${TF_WORKSPACE}-${GREEN_ENV}/ docker_tag=${DOCKER_TAG} ?" mainmenuinput
cd guestbook-service
terraform init -get -reconfigure
terraform workspace select ${TF_WORKSPACE}-${GREEN_ENV}
terraform apply -var docker_tag=${DOCKER_TAG} -auto-approve
cd -


read  -n 1 -p "You can preview new release ${GREEN_ENDPOINT} ... Want to promote ?" mainmenuinput
cd commons
terraform apply -var deployment_step=promote_green -auto-approve
read  -n 1 -p "Want to mark current green as new blue ?" mainmenuinput
terraform apply -var deployment_step=finalize_deployment -auto-approve
cd -

