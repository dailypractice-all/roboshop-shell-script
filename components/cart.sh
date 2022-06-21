curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

useradd roboshop

curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"
cd /home/roboshop
rm -rf cart
unzip /tmp/cart.zip
mv cart-main cart
cd cart
npm install

sed -i -e 's/REDIS_ENDPOINT/redis.dailypractice.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.dailypractice.internal/' /home/roboshop/cart/systemd.service

Update `REDIS_ENDPOINT` with REDIS server IP Address
Update `CATALOGUE_ENDPOINT` with Catalogue server IP address

mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl start cart
systemctl enable cart