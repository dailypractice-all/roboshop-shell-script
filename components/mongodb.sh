curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
yum install -y mongodb-org
systemctl enable mongod
systemctl start mongod
# Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file

# Config file: `/etc/mongod.conf`
# then restart the service
vim /etc/mongod.conf
# will add vim command to edit the file and will change the ip address 0.0.0.0 manually
systemctl restart mongod

# Every Database needs the schema to be loaded for the application to work.

# Download the schema and load it.
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
cd /tmp
unzip -o mongodb.zip
# in unzip -o mongodb.zip in this command i added -o to overwite the file and give permission to move forward

cd mongodb-main
mongo < catalogue.js
mongo < users.js

# Symbol `<` will take the input from a file and give that input to the command.