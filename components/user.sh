CHECK_ROOT() {
  USER_ID=$(id -u)
  if [ $USER_ID -ne 0 ]; then
    echo You are Non root user
    echo You can run this script as root user or with sodo
    exit 1
  fi
}

CHECK_ROOT

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

useradd roboshop

curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip"
cd /home/roboshop

rm -rf user

unzip /tmp/user.zip
mv user-main user
cd /home/roboshop/user
npm install


sed -i -e 's/REDIS_ENDPOINT/redis.dailypractice.internal/' -e 's/MONGO_ENDPOINT/mongodb.dailypractice.internal/' /home/roboshop/user/systemd.service

mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service
systemctl daemon-reload
systemctl restart user
systemctl enable user