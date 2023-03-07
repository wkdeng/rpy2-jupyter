##############################
# author [Wankun Deng]
# email [dengwankun@hotmail.com]
# create date 2023-02-15 18:33:53
# modify date 2023-02-16 00:23:44
# desc [description]
#############################
apt-get update -qq
apt-get install -y \
        apt-utils \
        apt-transport-https \
		dirmngr \
        gnupg \
		libcurl4-openssl-dev \
		libnlopt-dev \
        lsb-release \
		software-properties-common
apt-get update -qq
apt-key adv \
        --keyserver keyserver.ubuntu.com \
        --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
add-apt-repository \
        --yes \
        "deb ${CRAN_MIRROR}/bin/linux/ubuntu/ $(lsb_release -c -s) ${CRAN_MIRROR_TAG}/"
apt-get update -qq
apt-get install -y \
        aptdaemon \
        ed \
        git \
	mercurial \
	libcairo-dev \
	libedit-dev \
	libxml2-dev \
	python3 \
	python3-pip \
	python3-venv \
	graphviz \
	r-base \
	r-base-dev \
	wget 
rm -rf /var/lib/apt/lists/*
