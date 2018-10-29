data "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
}

data "aws_subnet_ids" "subnets" {
  vpc_id = "${data.aws_vpc.vpc.id}"
}

data "aws_route53_zone" "public_zone" {
  name = "steyssier.net"
}

data "terraform_remote_state" "shared" {
  backend = "s3"

  config {
    bucket = "mybucket-perso1"
    key    = "meetup-ecs-eks/shared/terraform.tfstate"
    region = "eu-west-1"
    profile = "perso"
  }
}