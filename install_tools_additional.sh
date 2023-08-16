##############################
# author [Wankun Deng]
# email [dengwankun@hotmail.com]
# create date 2023-02-15 18:35:24
# modify date 2023-02-16 00:24:39
# desc [description]
#############################
# install sra-toolkit
cd ~

wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.2/sratoolkit.3.0.2-ubuntu64.tar.gz
tar -xzvf sratoolkit.3.0.2-ubuntu64.tar.gz
cd sratoolkit.3.0.2-ubuntu64/bin
echo 'export PATH=/root/sratoolkit.3.0.2-ubuntu64/bin:$PATH' >> ~/.bashrc
cd ~

apt-get update -qq
apt-get install -y screen

add-apt-repository -y ppa:cran/imagemagick
apt-get update -qq
apt-get install -y libmagick++-dev

add-apt-repository ppa:dns/gnu
apt-get update -qq
apt install -y libgsl-dev

pip install scvi-tools
pip install scvi-colab
pip install --no-cache-dir cython
pip install --no-cache-dir velocyto

git clone https://github.com/KrishnaswamyLab/SAUCIE
pip install -r SAUCIE/requirements.txt
pip install --no-cache-dir scglue
pip install --no-cache-dir muon
pip install --no-cache-dir scvelo