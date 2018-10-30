resource "aws_cloudwatch_log_group" "application" {
  name              = "/ecs/${terraform.workspace}/demo/guestbook"
  retention_in_days = 7
}

data "aws_iam_policy_document" "execution_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name               = "tf-${terraform.workspace}-ecs-role"
  assume_role_policy = "${data.aws_iam_policy_document.execution_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attach" {
  role       = "${aws_iam_role.ecs_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


data template_file "service_definition" {
  template = "${file("${path.root}/templates/ecs_task.tpl")}"

  vars {
    container_name        = "guestbook"
    container_port        = "3000"
    docker_tag            = "${var.docker_tag}"
    docker_cpu            = "${var.ecs_task_size_cpu}"
    docker_memory         = "${var.ecs_task_size_memory}"
    aws_region            = "${var.aws_region}"
    cloudwatch_group_name = "${aws_cloudwatch_log_group.application.name}"
    environment           = "${terraform.workspace}"
    REDIS_CONNECTION      = "${data.terraform_remote_state.datastore.primary_endpoint_address}:6379"
  }
}

module "ecs_service" {
  source = "../modules/terraform-ecs-ec2-service-module"
  env = "${terraform.workspace}"

  project = "cd"
  ecs_cluster_name = "tf-meetup"
  container_port = "3000"
  aws_alb_target_group_service_arn = "${data.terraform_remote_state.commons.default_target_group_arn}"

  it_root_functional_area = "front"
  alarm_notification_topic_arn = ""
  service_name = "guestbook"
  ecs_service_iam_role_arn = ""
  ecs_task_iam_role_arn = ""
  ecs_task_execution_role_arn = "${aws_iam_role.ecs_execution_role.arn}"
  container_definitions_rendered = "${data.template_file.service_definition.rendered}"
  subnets = "${data.aws_subnet_ids.subnets.ids}"  
}