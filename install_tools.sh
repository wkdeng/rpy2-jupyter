##############################
# author [Wankun Deng]
# email [dengwankun@hotmail.com]
# create date 2023-02-15 18:35:24
# modify date 2023-02-16 00:24:39
# desc [description]
#############################
# install homer
cd ~
mkdir homer
cd homer
wget http://homer.ucsd.edu/homer/configureHomer.pl
perl configureHomer.pl  -install homer
perl configureHomer.pl  -install hg19
ln -s /root/homer/bin/findMotifsGenome.pl /usr/local/bin/findMotifsGenome.pl
cd ..

# install kallisto
wget https://github.com/pachterlab/kallisto/releases/download/v0.46.1/kallisto_linux-v0.46.1.tar.gz
tar -xzvf kallisto_linux-v0.46.1.tar.gz
cd kallisto
ln -s /root/kallisto/kallisto /usr/local/bin/kallisto
cd ..

# install STAR
wget https://github.com/alexdobin/STAR/archive/2.7.10a.tar.gz
tar -xzf 2.7.10a.tar.gz
cd STAR-2.7.10a/source
make STAR
ln -s /root/STAR-2.7.10a/source/STAR /usr/local/bin/STAR
cd ..

# install cufflinks
wget http://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-2.2.1.Linux_x86_64.tar.gz
tar -xzf cufflinks-2.2.1.Linux_x86_64.tar.gz
cd cufflinks-2.2.1.Linux_x86_64
rm AUTHORS LICENSE README
cp ./* /usr/local/bin/
cd ..
rm -rf cufflinks-2.2.1.Linux_x86_64

# install bwa
wget https://gigenet.dl.sourceforge.net/project/bio-bwa/bwa-0.7.17.tar.bz2
tar -xjvf bwa-0.7.17.tar.bz2
cd bwa-0.7.17
make
cp bwa /usr/local/bin/
cd ..
rm -rf bwa-0.7.17


## Modified from https://github.com/hisplan/docker-cellranger, using dropbox to avoid installation of scing

download_url="https://www.dropbox.com/s/h9mmenub0a7fjun/cellranger-7.1.0.tar"
version="7.1.0"

# cell ranger binaries
wget ${download_url} \
    && tar xf cellranger-${version}.tar \
    && rm -rf cellranger-${version}.tar \
    && mv cellranger-${version} /usr/local/bin/

ln -s /usr/local/bin/cellranger-${version}/bin/cellranger /usr/local/bin/cellranger

git clone https://github.com/JiekaiLab/scTE.git
cd scTE
python3 setup.py install
cd ..

