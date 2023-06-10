resource "aws_instance" "project" {
  ami           = "ami-04a0ae173da5807d3"  # Replace with the desired AWS Linux 2023 AMI ID
  instance_type = "t2.micro"  # Replace with the desired instance type
  key_name      = "LaptopKey"  # Replace with the name of your key pair
  associate_public_ip_address = true

  tags = {
    Name = "project-instance"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y

    # Install Apache web server
    yum install httpd -y
    systemctl start httpd
    systemctl enable httpd

    # Install MariaDB (a MySQL-compatible database server)
    yum install mariadb-server -y
    systemctl start mariadb
    systemctl enable mariadb

    # Secure MariaDB installation
    mysql_secure_installation <<EOF2

    y
    your_password
    your_password
    y
    y
    y
    y
    EOF2

    # Create a database for WordPress
    mysql -u root -p"your_password" -e "CREATE DATABASE wordpress;"
    mysql -u root -p"your_password" -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'your_password';"
    mysql -u root -p"your_password" -e "FLUSH PRIVILEGES;"

    # Install PHP and necessary extensions
    amazon-linux-extras install php7.4 -y
    yum install php-mysqlnd php-gd php-xml php-mbstring -y

    # Download and install WordPress
    cd /var/www/html
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* .
    cp wp-config-sample.php wp-config.php
    sed -i 's/database_name_here/wordpress/' wp-config.php
    sed -i 's/username_here/wordpress/' wp-config.php
    sed -i 's/password_here/your_password/' wp-config.php

    # Set correct permissions
    chown -R apache:apache /var/www/html
    find /var/www/html -type d -exec chmod 755 {} \;
    find /var/www/html -type f -exec chmod 644 {} \;

    # Restart Apache
    systemctl restart httpd
  EOF
}

# Security group resource
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "Security group for WordPress"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
