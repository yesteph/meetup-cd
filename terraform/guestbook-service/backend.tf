terraform {
  backend "s3" {
    bucket = "mybucket-perso1"
    key    = "meetup-ecs-eks/guestbook-service/terraform.tfstate"
    region = "eu-west-1"
    profile = "perso"
  }
}