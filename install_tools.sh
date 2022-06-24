cd ~
mkdir homer
cd homer
wget http://homer.ucsd.edu/homer/configureHomer.pl
perl configureHomer.pl  -install homer
perl configureHomer.pl  -install hg19
ln -s findMotifsGenome.pl /usr/local/bin/findMotifsGenome.pl
cd ..
wget https://github.com/pachterlab/kallisto/releases/download/v0.46.1/kallisto_linux-v0.46.1.tar.gz
tar -xzvf kallisto_linux-v0.46.1.tar.gz
cd kallisto
ln -s /root/kallisto/kallisto /usr/local/bin/kallisto
cd ..
wget https://github.com/alexdobin/STAR/archive/2.7.10a.tar.gz
tar -xzf 2.7.10a.tar.gz
cd STAR-2.7.10a/source
make STAR
ln -s /root/STAR-2.7.10a/source/STAR /usr/local/bin/STAR