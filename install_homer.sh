cd ~
mkdir homer
cd homer
wget http://homer.salk.edu/homer/install/installHomer.pl
perl http://homer.ucsd.edu/homer/configureHomer.pl  -install homer
perl http://homer.ucsd.edu/homer/configureHomer.pl  -install hg19
echo 'PATH=$PATH:~/homer/bin' >> /etc/profile