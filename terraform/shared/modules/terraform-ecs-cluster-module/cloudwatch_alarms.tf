resource "aws_cloudwatch_metric_alarm" "ecs_cluster_max_size_alarm" {
  alarm_name          = "${aws_autoscaling_group.ecs.name}-max-size-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "GroupInServiceInstances"
  namespace           = "AWS/AutoScaling"
  period              = "60"
  statistic           = "Average"
  threshold           = "${floor(aws_autoscaling_group.ecs.max_size * 0.9)}"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.ecs.name}"
  }

  alarm_description = "This metric monitor capacity versus max size for autoscaling group ${aws_autoscaling_group.ecs.name}."
  alarm_actions     = ["${var.alarm_notification_topic_arn}"]

  count = "${var.enable_alarm_creation == true ? 1:0}"
}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_oom" {
  alarm_name          = "${aws_autoscaling_group.ecs.name}-OOM"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "OOM"
  namespace           = "${local.component_id}-logmetrics"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"

  alarm_description = "This metric monitor Out of memory on ECS cluster ${var.cluster_name}."
  alarm_actions     = ["${var.alarm_notification_topic_arn}"]

  count = "${var.enable_alarm_creation == true ? 1:0}"
}

