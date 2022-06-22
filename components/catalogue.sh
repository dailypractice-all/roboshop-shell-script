USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
  echo You are Non root user
  echo You can run this script as root user or with sodo
  exit 1
fi

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"

cd /home/roboshop
unzip /tmp/catalogue.zip
mv catalogue-main catalogue
cd /home/roboshop/catalogue
npm install

sed -i -e 's/MONGO_DNSNAME/mongodb.dailypractice.internal/' /home/roboshop/catalogue/systemd.service

# Update SystemD file with correct IP addresses
# Update `MONGO_DNSNAME` with MongoDB Server IP
# Now, lets set up the service with systemctl.
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl restart catalogue
systemctl enable catalogue