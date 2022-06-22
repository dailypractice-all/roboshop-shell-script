source components/common.sh

CHECK_ROOT

PRINT "setting up NodeJS YUM Repo is "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
CHECK_STAT $?

PRINT "Installing Nodejs"
yum install nodejs -y &>>${LOG}
CHECK_STAT $?

PRINT "Creating Application User "
useradd roboshop &>>${LOG}
CHECK_STAT $?

PRINT "Downloading content of Roboshop "
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>${LOG}
CHECK_STAT $?

cd /home/roboshop

PRINT "Removing all content "
rm -rf cart &>>${LOG}
CHECK_STAT $?

PRINT "Extract Cart Zip "
unzip /tmp/cart.zip &>>${LOG}
CHECK_STAT $?

mv cart-main cart
cd cart

PRINT "Installing cart dependencies for cart component "
npm install &>>${LOG}
CHECK_STAT $?

PRINT "Updating SystemD Configuraton"
sed -i -e 's/REDIS_ENDPOINT/redis.dailypractice.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.dailypractice.internal/' /home/roboshop/cart/systemd.service &>>${LOG}
CHECK_STAT $?

PRINT "Setup SystemD Configuraton "
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>${LOG}
CHECK_STAT $?

systemctl daemon-reload
systemctl restart cart

PRINT "Start Cart Service "
systemctl enable cart &>>${LOG}
CHECK_STAT $?