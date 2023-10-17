data "aws_region" "current" {}

locals {
  common_tags = {
    "Region" = data.aws_region.current.name
  }
}

resource "aws_vpc" "jinwoo" {
  cidr_block = "10.0.0.0/16"

  tags = merge(
    local.common_tags,
    var.tags, 
    {
      Name = var.vpc_name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  public_subnets = [
    "10.0.0.0/24",
    "10.0.1.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
  ]
}

resource "aws_subnet" "public" {
  for_each = toset(local.public_subnets)

  vpc_id     = aws_vpc.jinwoo.id
  cidr_block = each.value

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-public-${each.key }"
    Hello = "What"
  })

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

locals {
  private_subnets = {
    "${var.vpc_name}-private-001" = {
      cidr_block = "10.0.10.0/24",
      az = "ap-northeast-1a"
    }
    "${var.vpc_name}-private-002" = {
      cidr_block = "10.0.11.0/24",
      az = "ap-northeast-1c"
    }
    "${var.vpc_name}-private-003" = {
      cidr_block = "10.0.12.0/24",
      az = "ap-northeast-1d"
    }
  }
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id     = aws_vpc.jinwoo.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name = each.key
  })
}

resource "random_pet" "server" {
  length = 3
}

resource "time_rotating" "example" {
  rotation_minutes = 1
}

resource "time_static" "rotate" {
  rfc3339 = time_rotating.example.rfc3339
}

resource "aws_eip" "this" {
  domain = "vpc"
  # provider = aws.verginia

  depends_on = [
    aws_subnet.public["10.0.0.0/24"]
  ]

  lifecycle {
    prevent_destroy = false
    replace_triggered_by = [
      # aws_vpc.jinwoo,
      # time_static.rotate
    ]
  }
}

locals {
  vpcs = ["hello", "world"]
}

module "vpc" {
  source = "tedilabs/network/aws//modules/vpc"
  version = "0.28.0"

  count = length(local.vpcs)
  name = local.vpcs[count.index]

  dhcp_options_enabled = true
  vpn_gateway_enabled = true
}