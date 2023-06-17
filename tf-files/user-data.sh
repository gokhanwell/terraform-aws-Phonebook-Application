#! /bin/bash
yum update -y
yum install python3 -y
pip3 install flask
pip3 install flask_mysql
yum install git -y
# TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
# cd /home/ec2-user && git clone https://$TOKEN@github.com/gokhanwell/terraform-aws-Phonebook-Application.git
cd /home/ec2-user && git clone https://github.com/gokhanwell/terraform-aws-Phonebook-Application.git
python3 /home/ec2-user/terraform-aws-Phonebook-Application/phonebook-app.py