locals {
  // get the green env ALB or the blue env if we overwrite it (dev case)
  is_a_or_b_env = "${substr(terraform.workspace, length(terraform.workspace) -1, 1)}"

  public_alb_default_target_group_arn        = "${local.is_a_or_b_env == "b" ? data.terraform_remote_state.commons.default_target_group_arn-b :  data.terraform_remote_state.commons.default_target_group_arn-a}"
  endpoint = "${local.is_a_or_b_env == "b" ? data.terraform_remote_state.commons.endpoint-b :  data.terraform_remote_state.commons.endpoint-a}"

 // private_alb_dns_alias = "${local.is_a_or_b_env == "b" ? data.terraform_remote_state.commons.private_alb_b_dns_alias  : data.terraform_remote_state.commons.private_alb_a_dns_alias }"
}
