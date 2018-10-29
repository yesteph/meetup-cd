terraform {
  backend "s3" {
    bucket = "mybucket-perso1"
    key    = "meetup-ecs-eks/shared/terraform.tfstate"
    region = "eu-west-1"
    profile = "perso"
  }
}