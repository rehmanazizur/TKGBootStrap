sudo apt update -y
echo "Update Completed!!"
sudo apt upgrade -y

echo "Upgrade Completed!!"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

echo "Removed Old packages!!"

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Added Docker's official GPG key"

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "Added the repository to Apt sources"

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Installed docker!!"

sudo groupadd docker || true
sudo usermod -aG docker $USER
newgrp docker

echo "Added current user to docker group!"

cat /etc/docker/daemon.json

echo "created /etc/docker/daemon.json file"
echo \
"{
    "exec-opts": ["native.cgroupdriver=systemd"]
}" >| /etc/docker/daemon.json

echo "added below contents to /etc/docker/daemon.json"
cat /etc/docker/daemon.jso
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "docker service restarted!"
ipv4.conf.all.rp_filter = 0
sudo sysctl net/netfilter/nf_conntrack_max=131072
sudo modprobe nf_conntrack
sudo apt update
sudo apt install -y ca-certificates curl gpg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub | sudo gpg --dearmor -o /etc/apt/keyrings/tanzu-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/tanzu-archive-keyring.gpg] https://storage.googleapis.com/tanzu-cli-os-packages/apt tanzu-cli-jessie main" | sudo tee /etc/apt/sources.list.d/tanzu.list
sudo apt update
sudo apt install tanzu-cli=1.1.0

echo "install Tanzu Cli 1.1.0"
tanzu plugin install --group vmware-tkg/default:v2.5.0

echo "installed tanzu plugins!!"
mkdir /ubuntu/home/tkg
cd /ubuntu/home/tkg
curl https://github.com/rehmanazizur/TKGBootStrap/blob/main/kubectl-linux-v1.27.5%2Bvmware.1.gz
echo "downloaded kubectl-linux-v1.28.4+vmware.1.gz"
gunzip kubectl-linux-v1.28.4+vmware.1.gz
chmod ugo+x kubectl-linux-v1.28.4+vmware.1
sudo install kubectl-linux-v1.28.4+vmware.1 /usr/local/bin/kubectl
