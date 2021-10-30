# create launch template for wordpress

resource "aws_launch_template" "wordpress-launch-template" {
  image_id = var.ami
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.instProfile.id
  }

  key_name = var.keypair

  placement {
    availability_zone = "random_shuffle.az_list.result"
  }
  
  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    
    tags = merge(
      var.tags,
      {
          Name = "wordpress-launch-template"
      },  
    )
  }

  user_data = filebase64("${path.module}/wordpress.sh")
}

# --- Autoscaling for wordpress application
resource "aws_autoscaling_group" "wordpress-asg" {
    name = "Wordpress-asg"
    max_size = 2
    min_size = 1
    health_check_grace_period = 300
    health_check_type = "ELB"
    desired_capacity = 1
    vpc_zone_identifier = [
        aws_subnet.private-A[0].id,
        aws_subnet.private-A[1].id
    ]

    launch_template {
      id = aws_launch_template.wordpress-launch-template.id
      version = "$Latest"
    }

    tag{
        key = "Name"
        value = "wordpress-asg"
        propagate_at_launch = true
    }
  
}

# attach wordpress autoscaling group to the internal load balancer
resource "aws_autoscaling_attachment" "asg-attachment-wordpress" {
   autoscaling_group_name = aws_autoscaling_group.wordpress-asg.id
   alb_target_group_arn = aws_lb_target_group.wordpress-tgt.arn
  
}


#---create launch template for tooling server
resource "aws_launch_template" "tooling-launch-template" {
  image_id = var.ami
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.webserver-sg.id  ]
  
  iam_instance_profile {
    name  = aws_iam_instance_profile.instProfile.id
  }

  key_name = var.keypair

  placement {
    availability_zone = "random_shuffle.az_list.result"
  }

  lifecycle {
     create_before_destroy  = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
        var.tags,
        {
            Name = "tooling-launch-template"
        },
    )
  }
  user_data = filebase64("${path.module}/tooling.sh")
}

# create autoscaling group for tooling webserver
resource "aws_autoscaling_group" "tooling-asg" {
   name = "tooling-asg"
   max_size = 2
   min_size = 1
   health_check_grace_period = 300
   health_check_type = "ELB"
   desired_capacity = 1

   vpc_zone_identifier = [
       aws_subnet.private-A[0].id,
       aws_subnet.private-A[1].id
   ]

   launch_template {
     id = aws_launch_template.tooling-launch-template.id
     version = "$Latest"
   }

   tag { 
       key = "Name"
       value = "tooling-launch-template"
       propagate_at_launch = true
   }  
}

# attaching tooling autoscaling group to the internal load balancer
resource "aws_autoscaling_attachment" "asg-attachment-tooling" {
    autoscaling_group_name = aws_autoscaling_group.tooling-asg.id
    alb_target_group_arn = aws_lb_target_group.tooling-tgt.arn  
}

