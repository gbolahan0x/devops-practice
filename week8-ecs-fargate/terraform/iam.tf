data "aws_iam_policy_document" "ecs_tasks_trust" {
  statement {
    sid     = "AllowECSTasks"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.aws_account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:*"
      ]
    }
  }
}

resource "aws_iam_role" "ecs_execution" {
  name                 = "${local.name_prefix}-ecs-execution"
  path                 = "/devops-zero-to-hero/"
  description          = "Allows ECS Fargate to pull the Week 8 image and publish logs."
  assume_role_policy   = data.aws_iam_policy_document.ecs_tasks_trust.json
  max_session_duration = 3600

  tags = {
    Name = "${local.name_prefix}-ecs-execution"
  }
}

resource "aws_iam_role" "ecs_task" {
  name                 = "${local.name_prefix}-ecs-task"
  path                 = "/devops-zero-to-hero/"
  description          = "Application role for the Week 8 container."
  assume_role_policy   = data.aws_iam_policy_document.ecs_tasks_trust.json
  max_session_duration = 3600

  tags = {
    Name = "${local.name_prefix}-ecs-task"
  }
}

data "aws_iam_policy_document" "ecs_execution" {
  statement {
    sid       = "AuthenticateToECR"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "PullWeek6Image"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]

    resources = [
      data.aws_ecr_repository.app.arn
    ]
  }

  statement {
    sid    = "PublishApplicationLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.app.arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "ecs_execution" {
  name   = "PullWeek6ImageAndPublishLogs"
  role   = aws_iam_role.ecs_execution.id
  policy = data.aws_iam_policy_document.ecs_execution.json
}
