# install homer
cd ~
mkdir homer
cd homer
wget http://homer.ucsd.edu/homer/configureHomer.pl
perl configureHomer.pl  -install homer
perl configureHomer.pl  -install hg19
ln -s findMotifsGenome.pl /usr/local/bin/findMotifsGenome.pl
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


## Credit to Jaeyoung Chun (chunj@mskcc.org) https://github.com/hisplan/docker-cellranger

site_url="https://support.10xgenomics.com/single-cell-gene-expression/software/downloads/7.0/"
download_url=""
version="7.0.0"

# get scing
git clone https://github.com/hisplan/scing.git
cd scing
python3 setup.py install
cd ..

# get download url for Cell Ranger
if [ ! -n "$download_url" ]
then
    if [ ! -x "$(command -v scing)" ]
    then
        echo "Please install SCING CLI (https://github.com/hisplan/scing)."
        exit 1
    fi

    out=`scing --no-logo download --site-url ${site_url}`
    if [ $? != 0 ]
    then
        echo "$out"
        exit 1
    fi
    download_url=$out
fi

# cell ranger binaries
RUN curl -o cellranger-${version}.tar.gz ${download_url} \
    && tar xzf cellranger-${version}.tar.gz \
    && rm -rf cellranger-${version}.tar.gz \
    && mv cellranger-${version} /usr/local/bin/

# V(D)J GRCh38 Reference - 7.0.0 (May 17, 2022)
RUN curl -O https://cf.10xgenomics.com/supp/cell-vdj/refdata-cellranger-vdj-GRCh38-alts-ensembl-${version}.tar.gz \
    && tar xzf refdata-cellranger-vdj-GRCh38-alts-ensembl-${version}.tar.gz \
    && rm -rf refdata-cellranger-vdj-GRCh38-alts-ensembl-${version}.tar.gz \
    && mv refdata-cellranger-vdj-GRCh38-alts-ensembl-${version} /usr/local/bin/

# V(D)J GRCm38 Reference - 7.0.0 (May 17, 2022)
RUN curl -O https://cf.10xgenomics.com/supp/cell-vdj/refdata-cellranger-vdj-GRCm38-alts-ensembl-${version}.tar.gz \
    && tar xzf refdata-cellranger-vdj-GRCm38-alts-ensembl-${version}.tar.gz \
    && rm -rf refdata-cellranger-vdj-GRCm38-alts-ensembl-${version}.tar.gz \
    && mv refdata-cellranger-vdj-GRCm38-alts-ensembl-${version} /usr/local/bin/
