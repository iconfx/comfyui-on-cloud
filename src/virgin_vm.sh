#!/bin/bash

# Update and upgrade the system
sudo apt-get update
sudo apt-get --assume-yes upgrade

# Install necessary packages
sudo apt-get --assume-yes install software-properties-common jq build-essential linux-headers-$(uname -r)

# Install Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-py311_24.5.0-0-Linux-x86_64.sh
chmod +x Miniconda3-py311_24.5.0-0-Linux-x86_64.sh
./Miniconda3-py311_24.5.0-0-Linux-x86_64.sh -b -p $HOME/miniconda3
~/miniconda3/bin/conda init bash

# Source bashrc to ensure conda is available
source ~/.bashrc

# Check GPU attachment
echo "Checking GPU attachment:"
lspci | grep -i nvidia

# Install CUDA 12.2
wget https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda_12.2.2_535.104.05_linux.run
sudo sh cuda_12.2.2_535.104.05_linux.run --silent --toolkit --driver

# Set up CUDA environment variables
echo 'export PATH=/usr/local/cuda-12.2/bin${PATH:+:${PATH}}' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
source ~/.bashrc

# Verify CUDA installation
nvidia-smi
nvcc --version

# Install PyTorch with CUDA support
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Test CUDA availability in PyTorch
echo -e "import torch\nprint(torch.cuda.is_available())\nprint(torch.cuda.get_device_name(0))" > test_cuda.py
python test_cuda.py


## run these lines in the vm to make sure port 8188 is open for external access
#sudo ufw allow 8188/tcp
#sudo ufw reload
#sudo firewall-cmd --zone=public --add-port=8188/tcp --permanent
#sudo firewall-cmd --reload
#sudo apt-get install iptables
#sudo iptables -A INPUT -p tcp --dport 8188 -j ACCEPT
