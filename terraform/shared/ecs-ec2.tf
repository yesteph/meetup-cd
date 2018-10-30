module "asg" {
  source = "modules/terraform-ecs-cluster-module"

  providers {
    aws = "aws"
  }

  cluster_name = "ec2"
  env = "demo"
  vpc_id = "${data.aws_vpc.vpc.id}"
  subnets = "${data.aws_subnet_ids.subnets.ids}"
  autoscaling_max_size = "3"
  autoscaling_min_size = "2"
  protect_resources = "false"
  it_business_unit = "continuousdev"
  it_root_functional_area = "front"
  aws_region = "eu-west-1"
  alarm_notification_topic_arn = ""
  enable_alarm_creation = "false"
}