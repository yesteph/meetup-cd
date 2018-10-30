locals {
  consul_blue_green_path = "public-read/cd-front/blue-green"
}

provider "consul" {
  version    = "~> 1.0"
  address    = "localhost:8500"
  scheme     = "http"
  datacenter = "dc1"
}

data "consul_keys" "blue_components" {
  datacenter = "dc1"
  //token      = "${data.aws_ssm_parameter.consul_token.value}"

  key {
    name    = "blue_env"
    path    = "${local.consul_blue_green_path}/blue-env"
    default = "a"
  }
}

data "consul_keys" "last_deployment_step" {
  datacenter = "dc1"
  //token      = "${data.aws_ssm_parameter.consul_token.value}"

  key {
    name    = "last_deployment_step"
    path    = "${local.consul_blue_green_path}/last-state"
    default = "finalize_deployment"
  }
}

resource "consul_keys" "blue_green_state" {
  datacenter = "dc1"
  //token      = "${data.aws_ssm_parameter.consul_token.value}"

  key {
    path   = "${local.consul_blue_green_path}/blue-env"
    value  = "${local.blue_components_for_consul}"
    delete = true
  }

  key {
    path   = "${local.consul_blue_green_path}/last-state"
    value  = "${local.deployment_step == "deploy_blue" ? "finalize_deployment" : local.deployment_step}"
    delete = true
  }
}
