data "aws_iam_policy_document" "github_oidc_trust" {
  statement {
    sid    = "AllowGitHubActions"
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        local.github_oidc_provider_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        local.github_legacy_subject,
        local.github_id_based_subject
      ]
    }
  }
}

resource "aws_iam_role" "github_ecr_push" {
  name                 = "GitHubActionsECRPush-week6"
  path                 = "/devops-zero-to-hero/"
  description          = "Allows the trusted GitHub workflow to push Week 6 images to ECR."
  assume_role_policy   = data.aws_iam_policy_document.github_oidc_trust.json
  max_session_duration = 3600

  tags = {
    Name    = "GitHubActionsECRPush-week6"
    Purpose = "Temporary GitHub Actions ECR delivery credentials"
  }
}

data "aws_iam_policy_document" "github_ecr_push" {
  statement {
    sid    = "AllowECRAuthentication"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowPushToWeek6Repository"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]

    resources = [
      aws_ecr_repository.app.arn
    ]
  }
}

resource "aws_iam_role_policy" "github_ecr_push" {
  name   = "PushImagesToWeek6Repository"
  role   = aws_iam_role.github_ecr_push.id
  policy = data.aws_iam_policy_document.github_ecr_push.json
}
