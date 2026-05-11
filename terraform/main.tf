resource "aws_instance" "Jenkins_server"{
    ami = "ami-0388e3ada3d9812da"   
    instance_type = "t3.micro"
    key_name = "ravi"
    tags = {
        name = "Jenkins_server"
    }

}