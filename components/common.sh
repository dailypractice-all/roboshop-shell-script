CHECK_ROOT() {
  USER_ID=$(id -u)
  if [ $USER_ID -ne 0 ]; then
    echo -e "\e[31mYou should be running this script as a root user or sudo this script\e[0m"
    exit 1
  fi
}

CHECK_STAT() {
echo "--------------------" >>${LOG}
if [ $1 -ne 0 ]; then
  echo -e "\e[31mFAILED\e[0m"
  echo -e "\n Check Log file - ${LOG} for errors\n"
  exit 2
else
  echo -e "\e[32mSUCESS\e[0m"
fi
}

LOG=/tmp/roboshop.log
rm -f $LOG

PRINT() {
  echo "------------$1----------" >>${LOG}
  echo "$1"
}

APP_COMMON_SETUP() {
    PRINT "Creating Application User "
    id roboshop &>>${LOG}
    if [ $? -ne 0 ]; then
      useradd roboshop &>>${LOG}
    fi
    CHECK_STAT $?

    PRINT "Downloading content of ${COMPONENT} "
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG}
    CHECK_STAT $?

    cd /home/roboshop

    PRINT "Removing all content "
    rm -rf ${COMPONENT} &>>${LOG}
    CHECK_STAT $?

    PRINT "Extract ${COMPONENT} Zip "
    unzip /tmp/${COMPONENT}.zip &>>${LOG}
    CHECK_STAT $?
}

SYSTEMMD() {

    PRINT "Updating SystemD Configuraton"
    sed -i -e 's/REDIS_ENDPOINT/redis.dailypractice.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.dailypractice.internal/' -e 's/MONGO_ENDPOINT/mongodb.dailypractice.internal/' -e 's/MONGO_DNSNAME/mongodb.dailypractice.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>${LOG}
    CHECK_STAT $?

    PRINT "Setup SystemD Configuraton "
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service && systemctl daemon-reload &>>${LOG}
    CHECK_STAT $?

    PRINT "Start ${COMPONENT} Service "
    systemctl enable ${COMPONENT} && systemctl restart ${COMPONENT} &>>${LOG}
    CHECK_STAT $?

NODEJS() {

  CHECK_ROOT

  PRINT "setting up NodeJS YUM Repo "
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  CHECK_STAT $?

  PRINT "Installing Nodejs"
  yum install nodejs -y &>>${LOG}
  CHECK_STAT $?

  APP_COMMON_SETUP

  PRINT "Installing ${COMPONENT} dependencies for ${COMPONENT} component "
  mv ${COMPONENT}-main ${COMPONENT} && cd ${COMPONENT} && npm install &>>${LOG}
  CHECK_STAT $?

  SYSTEMMD
}

NGINX() {

  APP_COMMON_SETUP

  PRINT "Organize ${COMPONENT} Content"
  mv ${COMPONENT}-main/* . && mv static/* . && rm -rf ${COMPONENT}-main README.md && mv localhost.conf /etc/nginx/default.d/roboshop.conf
  CHECK_STAT $?

  SYSTEMMD
}


MAVEN() {

  CHECK_ROOT

  PRINT "Installing Maven"
  yum install maven -y &>>${LOG}
  CHECK_STAT $?

  APP_COMMON_SETUP

  PRINT "Configure ${COMPONENT} content "
  mv ${COMPONENT}-main ${COMPONENT} && cd ${COMPONENT} && mvn clean package &>>${LOG} && mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar &>>${LOG}
  CHECK_STAT $?

  SYSTEMMD
}
}