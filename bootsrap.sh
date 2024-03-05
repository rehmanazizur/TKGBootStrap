echo "Updating system!!"
sudo apt update -y &> /dev/null;;
echo "Update Completed!!"

echo "Removing old packages now!!"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done &> /dev/null;

echo "Removed Old packages!!"

ehco "Updating System.."
# Add Docker's official GPG key:
sudo apt-get update -y &> /dev/null;
sudo apt-get install ca-certificates curl &> /dev/null;
sudo install -m 0755 -d /etc/apt/keyrings &> /dev/null;
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc &> /dev/null;
sudo chmod a+r /etc/apt/keyrings/docker.asc &> /dev/null;

echo "Added Docker's official GPG key"

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "Added the repository to Apt sources"

echo "Update after adding repository!!"
sudo apt-get update &> /dev/null;

echo "installing docker.."
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &> /dev/null;
echo "Installed docker!!"

echo "adding current user to docker group."
sudo usermod -aG docker $USER &> /dev/null;
newgrp docker

echo "Added current user to docker group!"

echo "creating file /etc/docker/daemon.json"
cat /etc/docker/daemon.json &> /dev/null;

echo "created /etc/docker/daemon.json file"
echo \
"{
    "exec-opts": ["native.cgroupdriver=systemd"]
}" >| /etc/docker/daemon.json

echo "added below contents to /etc/docker/daemon.json"
cat /etc/docker/daemon.jso
sudo systemctl daemon-reload &> /dev/null;
sudo systemctl restart docker &> /dev/null;

echo "docker service restarted!"
ipv4.conf.all.rp_filter = 0
sudo sysctl net/netfilter/nf_conntrack_max=131072
sudo modprobe nf_conntrack

echo "update system after the changes"
sudo apt update -y &> /dev/null;
sudo apt install -y ca-certificates curl gpg
sudo mkdir -p /etc/apt/keyrings &> /dev/null;
curl -fsSL https://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub | sudo gpg --dearmor -o /etc/apt/keyrings/tanzu-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/tanzu-archive-keyring.gpg] https://storage.googleapis.com/tanzu-cli-os-packages/apt tanzu-cli-jessie main" | sudo tee /etc/apt/sources.list.d/tanzu.list

echo "update again after adding new repos.."

sudo apt update -y &> /dev/null;

echo "Installing tanzu-cli=1.1.0"
sudo apt install tanzu-cli=1.1.0 &> /dev/null;

echo "installed Tanzu Cli 1.1.0"

echo "Installing tanzu plugins."
tanzu plugin install --group vmware-tkg/default:v2.5.0 &> /dev/null;

echo "installed tanzu plugins!!"

echo "install kubectl.."
gunzip kubectl-linux-v1.27.5+vmware.1.gz
chmod ugo+x kubectl-linux-v1.27.5+vmware.1
sudo install kubectl-linux-v1.27.5+vmware.1 /usr/local/bin/kubectl

echo "You machine is ready. Please type the command tanzu mc create -b <ip of your bootstrap VM> --ui --browser none"
ehco "Happy installing TKG!!"
