locals {
  name_prefix = "week10-${var.environment}"

  public_subnets = {
    public_a = {
      cidr = "10.100.1.0/24"
      az   = data.aws_availability_zones.available.names[0]
    }

    public_b = {
      cidr = "10.100.2.0/24"
      az   = data.aws_availability_zones.available.names[1]
    }
  }
}
