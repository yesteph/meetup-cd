resource "aws_ecs_task_definition" "task_definition" {
  family                = "${var.project}-${var.it_root_functional_area}-${var.service_name}"
  container_definitions = "${var.container_definitions_rendered}"
  cpu                   = "${var.ecs_task_size_cpu}"
  memory                = "${var.ecs_task_size_memory}"
  task_role_arn         = "${var.ecs_task_iam_role_arn}" // role of the app container
  execution_role_arn    = "${var.ecs_task_execution_role_arn}" // role of the ECS agent / docker daemon

  //volume = ["${var.volume_list}"]

  // FARGATE SPEC
  network_mode = "bridge"
  requires_compatibilities = ["EC2"]
}

resource "aws_ecs_service" "service" {
  name                              = "${var.env}-${var.project}-${var.it_root_functional_area}-${var.service_name}"
  cluster                           = "${data.aws_ecs_cluster.ecs_cluster.id}"
  task_definition                   = "${aws_ecs_task_definition.task_definition.arn}"
  desired_count                     = "${var.autoscaling_min_size}"
  health_check_grace_period_seconds = "${var.health_check_grace_period}"

  //launch_type = "EC2"
  launch_type = "EC2"

  scheduling_strategy = "REPLICA"
  deployment_maximum_percent = "200"
  deployment_minimum_healthy_percent = "100"

  /*placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  placement_strategy {
    type  = "spread"
    field = "instanceId"
  }*/

  lifecycle {
    ignore_changes = ["desired_count"]
  }

  iam_role = "${var.ecs_service_iam_role_arn}"

  load_balancer {
    target_group_arn = "${var.aws_alb_target_group_service_arn}"
    container_name   = "${var.service_name}"
    container_port   = "${var.container_port}"
  }
}
