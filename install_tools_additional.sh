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

# install plink
wget https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20231018.zip
mkdir plink
mv plink_linux_x86_64_20231018.zip plink/
cd plink 
unzip plink_linux_x86_64_20231018.zip
echo 'export PATH=/root/plink:$PATH' >> ~/.bashrc
cd ~

# picard
wget https://github.com/broadinstitute/picard/releases/download/2.27.5/picard.jar 
mv picard.jar /usr/bin/

mkdir bin
cd bin
wget https://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/liftOver
chmod +x liftOver
echo 'export PATH=/root/bin:$PATH' >> ~/.bashrc
cd ~

# install DaPars2
git clone https://github.com/3UTR/DaPars2.git
echo "alias DaPars2_Multi_Sample_Multi_Chr='python3 /root/DaPars2/src/DaPars2_Multi_Sample_Multi_Chr.py '">> ~/.bashrc
echo "alias DaPars_Extract_Anno='python3 /root/DaPars2/src/DaPars_Extract_Anno.py '">> ~/.bashrc
echo "alias DaPars2_Multi_Sample='python3 /root/DaPars2/src/Dapars2_Multi_Sample.py '">> ~/.bashrc

# install subreads
wget https://github.com/ShiLab-Bioinformatics/subread/releases/download/2.0.2/subread-2.0.2-Linux-x86_64.tar.gz
tar -xzvf subread-2.0.2-Linux-x86_64.tar.gz
echo 'export PATH=/root/subread-2.0.2-Linux-x86_64/bin:$PATH' >> ~/.bashrc

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
pip install --no-cache-dir Cython
pip install --no-cache-dir velocyto

git clone https://github.com/KrishnaswamyLab/SAUCIE
pip install -r SAUCIE/requirements.txt
pip install --no-cache-dir scglue
pip install --no-cache-dir muon
pip install --no-cache-dir scvelo
pip install --no-cache-dir umi_tools
pip install --no-cache-dir pysam


## move app folder to /usr/bin, pay attention to two beagle version was needed, do not overwrite samtools, bcftools, vcftools
git clone https://github.com/KChen-lab/Monopogen.git
cd Monopogen
pip install -e .
echo "alias Monopogen='python3 /root/Monopogen/src/monopogen.py'">> ~/.bashrc
source ~/.bashrc
cd apps
wget https://faculty.washington.edu/browning/beagle/beagle.08Feb22.fa4.jar
chmod +x ./*
# cp picard.jar /usr/bin/
cp beagle.27Jul16.86a.jar /usr/bin/
cp beagle.08Feb22.fa4.jar /usr/bin/
cd ~

