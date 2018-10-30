locals{
  default_target_group_arn = "${terraform.workspace = -a}" ? data.terraform_remote_state.commons.default_target_group_arn-a
}