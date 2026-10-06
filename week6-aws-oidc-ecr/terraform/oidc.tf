resource "aws_iam_openid_connect_provider" "github" {
  count = var.create_github_oidc_provider ? 1 : 0

  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Name    = "github-actions"
    Purpose = "GitHub Actions temporary AWS authentication"
  }
}

data "aws_iam_openid_connect_provider" "github" {
  count = var.create_github_oidc_provider ? 0 : 1

  url = "https://token.actions.githubusercontent.com"
}

locals {
  github_oidc_provider_arn = var.create_github_oidc_provider ? (
    aws_iam_openid_connect_provider.github[0].arn
    ) : (
    data.aws_iam_openid_connect_provider.github[0].arn
  )

  github_legacy_subject = join("", [
    "repo:",
    var.github_owner,
    "/",
    var.github_repository,
    ":ref:refs/heads/",
    var.github_branch
  ])

  github_id_based_subject = join("", [
    "repo:",
    var.github_owner,
    "@",
    var.github_owner_id,
    "/",
    var.github_repository,
    "@",
    var.github_repository_id,
    ":ref:refs/heads/",
    var.github_branch
  ])
}
