output "instance_profile_name" {
    description = "Profile name of the instance"
    value = aws_iam_instance_profile.iris.name
}