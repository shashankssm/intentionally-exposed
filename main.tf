locals {
  users = [
    "Tom",
    "Bob",
    "John"
  ]
}

resource "aws_iam_group" "platform_developers" {
  name = "Platform-Developers"
}

resource "aws_iam_user" "users" {
  for_each = toset(local.users)

  name = each.value
}

resource "aws_iam_user_login_profile" "console_access" {
  for_each = aws_iam_user.users

  user                    = each.value.name
  password_reset_required = true
  password_length         = 16

  pgp_key = ""
}

resource "aws_iam_group_membership" "developers" {
  name = "PlatformDevelopersMembership"

  users = [
    for user in aws_iam_user.users : user.name
  ]

  group = aws_iam_group.platform_developers.name
}
