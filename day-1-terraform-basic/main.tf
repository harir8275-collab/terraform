resource "aws_instance" "example" {
  ami           = "ami-0ed094fb1304fd857"
  instance_type = "t2.micro"
}