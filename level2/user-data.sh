#!/bin/bash
yum update -y
yum install -y httpd git

# Clone the 2048 repository
git clone https://github.com/gabrielecirulli/2048.git /tmp/2048

# Copy the files to the web server's document root
cp -R /tmp/2048/* /var/www/html

# Set ownership and permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Start and enable the Apache service
systemctl start httpd
systemctl enable httpd
