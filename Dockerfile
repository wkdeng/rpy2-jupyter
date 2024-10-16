##############################
# author [Wankun Deng]
# email [dengwankun@hotmail.com]
# create date 2023-02-15 18:34:05
# modify date 2023-02-16 00:23:54
# desc [description]
#############################
FROM ubuntu:jammy
LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"


# ###### Install rpy2 (Modified from: github.com/rpy2/rpy2-docker) ######
ARG DEBIAN_FRONTEND=noninteractive
ENV CRAN_MIRROR=https://cloud.r-project.org \
    CRAN_MIRROR_TAG=-cran40 \
    DEBIAN_FRONTEND=noninteractive \
    SHELL=/bin/bash

SHELL ["/bin/bash", "-c"]
ARG RPY2_VERSION=RELEASE_3_5_1
ARG RPY2_CFFI_MODE=BOTH

COPY install_apt.sh /opt/
COPY install_rpacks.sh /opt/
COPY install_pip.sh /opt/

SHELL ["/bin/bash", "-c"]
RUN \
    apt-get update -qq \
    && apt-get install -y wget

RUN \
    cd /root \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
RUN \
    cd /root \
    && chmod +x Miniconda3-latest-Linux-x86_64.sh \
    && ./Miniconda3-latest-Linux-x86_64.sh -b 
RUN \
    echo 'export PATH=/root/miniconda3/bin:$PATH' >> ~/.bashrc \ 
    && source ~/.bashrc \
    && conda init
RUN \
    conda install -y pip

RUN \
    bash /opt/install_apt.sh \
    && bash /opt/install_rpacks.sh \
    && bash /opt/install_pip.sh \
    && rm -rf /tmp/* \
    && apt-get remove --purge -y $BUILDDEPS \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* \
    && python3 -m pip --no-cache-dir install https://github.com/rpy2/rpy2/archive/"${RPY2_VERSION}".zip \
    && rm -rf /root/.cache

RUN \
    cd /root \
    && wget https://github.com/samtools/htslib/releases/download/1.21/htslib-1.21.tar.bz2 \
    && tar -xvf htslib-1.21.tar.bz2 \
    && cd htslib-1.21 \
    && ./configure \
    && make \
    && make install \
    && ln -s /usr/local/bin/tabix /usr/bin/tabix \
    && ln -s /usr/local/bin/bgzip /usr/bin/bgzip

RUN \
    cd /root \
    && wget https://github.com/samtools/samtools/releases/download/1.21/samtools-1.21.tar.bz2 \
    && tar -xvf samtools-1.21.tar.bz2 \
    && cd samtools-1.21 \
    && ./configure \
    && make \
    && make install \
    && ln -s /usr/local/bin/samtools /usr/bin/samtools

RUN \
    cd /root \
    && wget https://github.com/samtools/bcftools/releases/download/1.21/bcftools-1.21.tar.bz2 \
    && tar -xvf bcftools-1.21.tar.bz2 \
    && cd bcftools-1.21 \
    && ./configure \
    && make \
    && make install \
    && ln -s /usr/local/bin/bcftools /usr/bin/bcftools

# # ###### Install Jupyter (Modified from: github.com/rpy2/rpy2-docker) ######
# # FROM dengwankun/bioinfo_env:rpy2_base
# # LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"

ARG RPY2_VERSION=master
ARG DEBIAN_FRONTEND=noninteractive
ENV JUPYTER_ENABLE_LAB=1
ARG TINI_VERSION=v0.19.0
ENV SHELL=/bin/bash \
    NB_USER=jupyteruser \
    NB_UID=1000
USER root

COPY install_jupyter.sh /opt/install_jupyter.sh
COPY setup_jupyter.sh /opt/setup_jupyter.sh
COPY install_nodejs_npm.sh /opt/install_nodejs_npm.sh

RUN apt-get update -qq \
    && apt-get install -y curl  \
    && apt-get remove -y --purge nodejs npm  \
    && chmod +x /opt/install_nodejs_npm.sh && /opt/install_nodejs_npm.sh \
    && apt-get install -y nodejs  \
    && wget -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -  \
    && apt-get update -qq  \
    && apt-get install -y yarn  \
    && npm install -g configurable-http-proxy  \
    && rm -rf /var/lib/apt/lists/*  \
    && useradd -m -s /bin/bash -N -u "${NB_UID}" "${NB_USER}"  \
    && sh /opt/install_jupyter.sh \
    && echo "${NB_USER}" 'ALL=(ALL) NOPASSWD: /usr/bin/apt-get' >> /etc/sudoers \
    && wget --quiet https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini -P /usr/local/bin/ \
    && chmod +x /usr/local/bin/tini \
    && sh /opt/setup_jupyter.sh \
    && echo "Add Jupyter scripts emerging as ad hoc interface" \
    && git clone --depth=1 https://github.com/jupyter/docker-stacks.git /tmp/docker-stacks \
    && cd /tmp/docker-stacks/base-notebook \
    && rm -rf /tmp/docker-stacks


# ###### Install required packages ######
# FROM dengwankun/bioinfo_env:jpt_base
# LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"
COPY dependencies.sys requirements.txt packages.R install_tools.sh /tmp/
ENV SHELL=/bin/bash
USER root

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
    && sed -i -e 's|disco|focal|g' /etc/apt/sources.list \
    && echo "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" >> /etc/apt/sources.list \
    && apt-get update -qq \
    && xargs apt-get -y --no-install-recommends install < /tmp/dependencies.sys \
    && apt-get clean \
    && apt-get autoremove \ 
    && bash /tmp/install_tools.sh \
    && rm -rf /var/lib/apt/lists/* 
# RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install --no-cache-dir scipy
RUN pip3 install --no-cache-dir statistics
RUN pip3 install --no-cache-dir statsmodels
RUN pip3 install --no-cache-dir pybedtools
RUN pip3 install --no-cache-dir sklearn
RUN pip3 install --no-cache-dir scikit-learn
RUN pip3 install --no-cache-dir snakemake
RUN pip3 install --no-cache-dir matplotlib
RUN pip3 install --no-cache-dir mappy
RUN pip3 install --no-cache-dir cutadapt
RUN pip3 install --no-cache-dir pyBigWig
RUN pip3 install --no-cache-dir HTSeq
RUN pip3 install --no-cache-dir pysam
RUN pip3 install --no-cache-dir PyYAML
RUN pip3 install --no-cache-dir pyenchant
RUN pip3 install --no-cache-dir numpy --upgrade --force-reinstall
RUN pip3 install --no-cache-dir umap-learn
RUN pip3 install --no-cache-dir jupyterthemes
RUN pip3 install --no-cache-dir torch
RUN pip3 install --no-cache-dir torchvision
RUN pip3 install --no-cache-dir tensorboard
RUN pip3 install --no-cache-dir graphviz
RUN pip3 install --no-cache-dir torchviz
RUN pip3 install --no-cache-dir onnx
RUN pip install git+https://github.com/snakemake/snakemake
#Single Cell
RUN pip3 install --no-cache-dir Scanpy
RUN pip3 install --no-cache-dir cell2location
# RUN pip3 install --no-cache-dir cellphonedb
RUN pip3 install --no-cache-dir mgatk
RUN pip3 install --no-cache-dir mquad
RUN pip3 install --no-cache-dir -U vireoSNP
RUN pip3 install --no-cache-dir -U cellSNP

RUN jt -t monokai -f fira -fs 10 -nf ptsans -nfs 11 -N -kl -cursw 2 -cursc r -cellw 95% -T 
# RUN jupyter labextension install @jupyterlab/toc 
RUN R -f /tmp/packages.R

# ###### Install required packages ######
# FROM dengwankun/bioinfo_env:jpt_svr2
# LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"
COPY install_tools_additional.sh packages_additional.R /tmp/
ENV SHELL=/bin/bash
USER root

# echo 'GITHUB_PAT=xxxxxxxxxx' >~/.Renviron \

RUN  bash /tmp/install_tools_additional.sh \
    && rm -rf /var/lib/apt/lists/* 

RUN R -f /tmp/packages_additional.R

EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["/init"]
