resource "aws_subnet" "choria_emulator" {
  vpc_id                  = aws_vpc.choria_emulator.id
  cidr_block              = var.emulator_subnet_cidr
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.gateway]
  tags                    = var.tags
}

resource "aws_route_table_association" "default" {
  subnet_id      = aws_subnet.choria_emulator.id
  route_table_id = aws_route_table.default.id
}
