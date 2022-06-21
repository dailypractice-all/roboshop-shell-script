curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
yum install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld



# /var/log/mysqld.log

# Next, We need to change the default root password in order to start using the database service. Use password `RoboShop@1` or any other as per your choice. Rest of the options you can choose `No`

# mysql_secure_installation
# mysql -uroot -pRoboShop@1

#curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#Load the schema for Services.
#cd /tmp
#unzip mysql.zip
#cd mysql-main
#mysql -u root -pRoboShop@1 <shipping.sql