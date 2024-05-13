$!/bin/bash



#  Ubuntu Server Setup



sudo apt update -y
sudo apt upgrade -y
sudo apt install xfce4-goodies xfce4 xrdp wget mc software-properties-common apt-transport-https gh firefox ca-certificates curl -y
sudo hostnamectl set-hostname admin1
sudo timedatectl set-timezone America/Los_Angeles



sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt upgrade -y 
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y


sudo adduser quasar
sudo usermod -aG docker quasar
sudo usermod -aG sudo quasar

#update quasar user - manually add to the docker and sudo group
# create .ssh folder
# copy authorized-keys from ubuntu user  to quasar - set permissions 700 for .ssh folder and 600 for authorized-keys file

wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

sudo apt install code -y

