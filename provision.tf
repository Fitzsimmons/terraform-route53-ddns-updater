variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "domain_name" {}

provider "aws" {
  region = "us-east-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

data "http" "external_ip_address" {
  url = "https://icanhazip.com"
}

resource "aws_route53_record" "root" {
  zone_id = "${var.zone_id}"
  name = "${var.domain_name}"
  type = "A"
  ttl = "1"
  records = ["${trimspace(data.http.external_ip_address.body)}"]
}
