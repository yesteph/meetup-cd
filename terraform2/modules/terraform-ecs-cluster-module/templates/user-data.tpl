#!/bin/bash
echo ECS_CLUSTER=tf-meetup >> /etc/ecs/ecs.config

sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo start amazon-ssm-agent