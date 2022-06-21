#!bin/bash


yum install nginx -y
systemctl enable nginx
systemctl start nginx
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
sed -i -e '/catalogue/ s/localhost/catalogue.dailypractice.internal/' -e '/user/ s/localhost/user.dailypractice.internal/' -e '/cart/ s/localhost/cart.dailypractice.internal/' /etc/nginx/default.d/roboshop.conf
systemctl restart nginx