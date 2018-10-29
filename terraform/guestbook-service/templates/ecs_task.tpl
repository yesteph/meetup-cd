[
  {
    "name": "${container_name}",
    "image": "980260041115.dkr.ecr.eu-west-1.amazonaws.com/guestbook:${docker_tag}",
    "cpu": ${docker_cpu},
    "memory": ${docker_memory},
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${container_port},
        "protocol": "tcp"
      }
    ],
    "environment": [
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${aws_region}",
        "awslogs-group": "${cloudwatch_group_name}",
        "awslogs-stream-prefix": "${container_name}"
      }
    }
  }
]