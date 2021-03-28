resource "aws_ec2_transit_gateway" "example" {
  description = "pangw-test"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags = var.tags
}
