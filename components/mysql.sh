USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
  echo You are Non root user
  echo You can run this script as root user or with sodo
  exit 1
fi

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
yum install mysql-community-server -y
systemctl enable mysqld
systemctl restart mysqld

MYSQL_DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')

# HERE TO SET THE DEFAULT PASSWORD RUN SUDO COMMAND WITH (grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}') AND WILL GET THE TEMPORARY PASSWORD AND AWK IS USED TO GET PASSWORD TFROM COULMN AND $ NF IS USED FOR NTH FEILD IF WE USE $ THEN IT COLLRILATES TO COLUMN 1..... IT CONCLUED THAT IF WE RUN SOME COMMAND THE OUTPUT WHICH COMES IT GOES TO THE VARIABLE.

echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" | mysql --connect-expired-password -uroot -p"${MYSQL_DEFAULT_PASSWORD}"
echo "uninstall plugin validate_password;" | mysql -uroot -p"${MYSQL_PASSWORD}"

# so till now we were using sudo make mysql in that we are using environment variable so now for this we will use sudo -E make mysql then only the variable will work

curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
cd /tmp
unzip -o mysql.zip
cd mysql-main
mysql -u root -p"${MYSQL_PASSWORD}" <shipping.sql
