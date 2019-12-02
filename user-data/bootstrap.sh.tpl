#!/bin/sh

### Download & Install Docker//Docker-compose
sudo yum update -y
sudo yum install -y docker 
sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
sudo chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo service docker start

### Download project from github
cd /home/ec2-user
sudo yum install -y git
git clone https://github.com/luizm/example-docker-applications
sudo chmod +x example-docker-applications/
cd example-docker-applications/

### Launching the app
sudo usermod -aG docker $USER
sudo chown $USER /var/run/docker.sock
sudo service docker start
docker-compose build
docker-compose up -d

### running a vulnerabilitie scanner

mkdir /home/ec2-user/report_scanning
sudo chmod +x home/ec2-user/report_scanning
cd /home/ec2-user
wget https://github.com/Arachni/arachni/releases/download/v1.4/arachni-1.4-0.5.10-linux-x86_64.tar.gz 
tar -xvf arachni-1.4-0.5.10-linux-x86_64.tar.gz 
cd arachni-1.4-0.5.10/bin/
sudo ./arachni --output-verbose --scope-include-subdomains http://127.0.0.2:8080 --report-save-path=report.afr
sudo ./arachni_reporter report.afr --reporter=html:outfile=/home/ec2-user/report_scanning/vulnerability_report.html.zip
cd /home/ec2-user/report_scanning
sudo aws s3 cp vulnerability_report.html.zip s3://vulerability-reportniceapp-2019



