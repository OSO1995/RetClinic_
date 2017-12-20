sudo -i
echo "Installing"
apt-get update 
apt-get install -y default-jdk 
apt-get install -y default-jre 
apt-get install -y git 

wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add - 
echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list 
apt-get update 
apt-get install -y jenkins 
apt-get install -y maven 
PYTH_VBOX=`pwd`
HOME_JENKINS=/var/lib/jenkins
sed -i "/HTTP_PORT/s/8080/8081/g" /etc/default/jenkins
service jenkins restart
echo "Success"
echo "Sleep"
sleep 60s

git clone https://github.com/krismal95/ssu_petClinic.git



cp /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar /usr/bin/jenkins-cli.jar
chmod 777 /usr/bin/jenkins-cli.jar

JENKINS_PASSWORD=$(cat /var/lib/jenkins/secrets/initialAdminPassword ) 

echo "jenkins.model.Jenkins.instance.securityRealm.createAccount('ser', 'ser')" | java -jar /usr/bin/jenkins-cli.jar -s http://localhost:8081/ groovy = --username admin --password $JENKINS_PASSWORD
echo "plugin install"
java -jar /usr/bin/jenkins-cli.jar -s http://127.0.0.1:8081/ install-plugin git --username admin --password $JENKINS_PASSWORD
java -jar /usr/bin/jenkins-cli.jar -s http://127.0.0.1:8081/ install-plugin git-client --username admin --password $JENKINS_PASSWORD
service jenkins restart
echo "Sleep"
sleep 30s
echo "End"

#copy jobs
cp -rp $PYTH_VBOX/ssu_petClinic/jobs/* $HOME_JENKINS/jobs
chown -R jenkins:jenkins $HOME_JENKINS/jobs/*
chown -R jenkins:jenkins $HOME_JENKINS/jobs


#port guest->host
iptables -I INPUT 1 -p tcp --dport 8081 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 8090 -j ACCEPT


service jenkins restart
echo "Success 2"