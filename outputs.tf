output "vpc" {
  description = "The ID of the VPC"
  value = aws_vpc.jinwoo
}

output "common_tags" {
  value = local.common_tags
}

output "region" {
  value = data.aws_region.current.name
}