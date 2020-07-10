resource "aws_vpc" "eksvpc" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terraform-eksvpc-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_subnet" "ekssubnet" {
  count = 2

  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.eksvpc.id

  tags = map(
    "Name", "terraform-eksvpc-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_internet_gateway" "eksintgateway" {
  vpc_id = aws_vpc.eksvpc.id

  tags = {
    Name = "terraform-eksintgateway"
  }
}

resource "aws_route_table" "eksrtable" {
  vpc_id = aws_vpc.eksvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eksintgateway.id
  }
}

resource "aws_route_table_association" "eksrtableacsn" {
  count = 2

  subnet_id      = aws_subnet.ekssubnet.*.id[count.index]
  route_table_id = aws_route_table.eksrtable.id
}
