##############################
# author [Wankun Deng]
# email [dengwankun@hotmail.com]
# create date 2023-02-15 18:34:05
# modify date 2023-02-16 00:23:54
# desc [description]
#############################
# FROM ubuntu:jammy
# LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"


###### Install rpy2 (Modified from: github.com/rpy2/rpy2-docker) ######
###### Generating jpt_svr10 ######

# ARG DEBIAN_FRONTEND=noninteractive
# ENV CRAN_MIRROR=https://cloud.r-project.org \
#     CRAN_MIRROR_TAG=-cran40 \
#     DEBIAN_FRONTEND=noninteractive \
#     SHELL=/bin/bash

# ARG RPY2_VERSION=RELEASE_3_5_1
# ARG RPY2_CFFI_MODE=BOTH

# COPY install_apt.sh /opt/
# COPY install_rpacks.sh /opt/
# COPY install_pip.sh /opt/

# RUN \
#     apt-get update -qq \
#     && apt-get install -y wget

# RUN \
#     cd /root \
#     && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
# RUN \
#     cd /root \
#     && chmod +x Miniconda3-latest-Linux-x86_64.sh \
#     && bash ./Miniconda3-latest-Linux-x86_64.sh -b 
# ENV PATH=/root/miniconda3/bin:${PATH}
# RUN conda update -y conda
# RUN conda init
# RUN conda install -y pip

# RUN \
#     bash /opt/install_apt.sh \
#     && bash /opt/install_rpacks.sh \
#     && bash /opt/install_pip.sh \
#     && rm -rf /tmp/* \
#     && apt-get remove --purge -y $BUILDDEPS \
#     && apt-get autoremove -y \
#     && apt-get autoclean -y \
#     && rm -rf /var/lib/apt/lists/* \
#     && python3 -m pip --no-cache-dir install https://github.com/rpy2/rpy2/archive/"${RPY2_VERSION}".zip \
#     && rm -rf /root/.cache

# RUN \
#     cd /root \
#     && wget https://github.com/samtools/htslib/releases/download/1.21/htslib-1.21.tar.bz2 \
#     && tar -xvf htslib-1.21.tar.bz2 \
#     && cd htslib-1.21 \
#     && ./configure \
#     && make \
#     && make install \
#     && ln -s /usr/local/bin/tabix /usr/bin/tabix \
#     && ln -s /usr/local/bin/bgzip /usr/bin/bgzip

# RUN \
#     cd /root \
#     && wget https://github.com/samtools/samtools/releases/download/1.21/samtools-1.21.tar.bz2 \
#     && tar -xvf samtools-1.21.tar.bz2 \
#     && cd samtools-1.21 \
#     && ./configure \
#     && make \
#     && make install \
#     && ln -s /usr/local/bin/samtools /usr/bin/samtools

# RUN \
#     cd /root \
#     && wget https://github.com/samtools/bcftools/releases/download/1.21/bcftools-1.21.tar.bz2 \
#     && tar -xvf bcftools-1.21.tar.bz2 \
#     && cd bcftools-1.21 \
#     && ./configure \
#     && make \
#     && make install \
#     && ln -s /usr/local/bin/bcftools /usr/bin/bcftools


###### Install Jupyter (Modified from: github.com/rpy2/rpy2-docker) ######
###### Generating jpt_svr12 (jpt_svt11 merged to this step and skipped) ######
# FROM dengwankun/bioinfo_env:jpt_svr10
# LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"

# ARG RPY2_VERSION=master
# ARG DEBIAN_FRONTEND=noninteractive
# ENV JUPYTER_ENABLE_LAB=1
# ARG TINI_VERSION=v0.19.0
# ENV SHELL=/bin/bash \
#     NB_USER=jupyteruser \
#     NB_UID=1000
# USER root

# COPY install_jupyter.sh /opt/install_jupyter.sh
# COPY setup_jupyter.sh /opt/setup_jupyter.sh
# COPY install_nodejs_npm.sh /opt/install_nodejs_npm.sh

# RUN wget --quiet https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini -P /usr/local/bin/ \
#     && chmod +x /usr/local/bin/tini 
# RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" \
#     && rm /etc/apt/sources.list.d/archive_uri-https_cloud_r-project_org_bin_linux_ubuntu_-jammy.list\
#     && apt-get update -qq \
#     && apt-get install -y curl \
#     && apt-get remove -y --purge nodejs npm  \
#     && chmod +x /opt/install_nodejs_npm.sh && /opt/install_nodejs_npm.sh \
#     && apt-get install -y nodejs  \
#     && wget -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -  \
#     && apt-get update -qq  \
#     && apt-get install -y yarn  \
#     && npm install -g configurable-http-proxy  \
#     && rm -rf /var/lib/apt/lists/*  \
#     && useradd -m -s /bin/bash -N -u "${NB_UID}" "${NB_USER}"  \
#     && sh /opt/install_jupyter.sh \
#     && echo "${NB_USER}" 'ALL=(ALL) NOPASSWD: /usr/bin/apt-get' >> /etc/sudoers \
#     && sh /opt/setup_jupyter.sh 
    ### removed 
    # && echo "Add Jupyter scripts emerging as ad hoc interface" \
    # && git clone --depth=1 https://github.com/jupyter/docker-stacks.git /tmp/docker-stacks \
    # && cd /tmp/docker-stacks/base-notebook \
    # && rm -rf /tmp/docker-stacks


###### Install required packages ######
###### Generating jpt_svr13 ######

# FROM dengwankun/bioinfo_env:jpt_svr12
# LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"
# COPY dependencies.sys requirements.txt packages.R install_tools.sh /tmp/
# ENV SHELL=/bin/bash
# USER root

# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
#     && sed -i -e 's|disco|focal|g' /etc/apt/sources.list \
#     && echo "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" >> /etc/apt/sources.list \
#     && apt-get update -qq \
#     && xargs apt-get -y --no-install-recommends install < /tmp/dependencies.sys \
#     && apt-get clean \
#     && apt-get autoremove \ 
#     && bash /tmp/install_tools.sh \
#     && rm -rf /var/lib/apt/lists/* 
# # RUN ln -s /usr/bin/python3 /usr/bin/python
# RUN pip3 install --no-cache-dir scipy statistics statsmodels pybedtools scikit-learn snakemake matplotlib mappy \
#          cutadapt pyBigWig HTSeq pysam PyYAML pyenchant
# RUN pip3 install --no-cache-dir numpy --upgrade --force-reinstall
# RUN pip3 install --no-cache-dir umap-learn jupyterthemes torch torchvision tensorboard graphviz torchviz onnx
# # RUN pip install git+https://github.com/snakemake/snakemake
# #Single Cell
# RUN pip3 install --no-cache-dir Scanpy cell2location mgatk mquad 
# RUN pip3 install --no-cache-dir -U vireoSNP cellSNP

# RUN jt -t monokai -f fira -fs 10 -nf ptsans -nfs 11 -N -kl -cursw 2 -cursc r -cellw 95% -T 
# # RUN jupyter labextension install @jupyterlab/toc 
# RUN R -f /tmp/packages.R

###### Install required packages ######
###### Generating jpt_svr14 ######
# FROM dengwankun/bioinfo_env:jpt_svr13
# LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"
# COPY install_tools_additional.sh packages_additional.R /tmp/
# ENV SHELL=/bin/bash
# USER root

# RUN  bash /tmp/install_tools_additional.sh \
#     && rm -rf /var/lib/apt/lists/* 

# RUN R -f /tmp/packages_additional.R


###### Install required packages ######
###### Generating jpt_svr15 ######
FROM dengwankun/bioinfo_env:jpt_svr14
LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"
USER root

# SHELL ["conda", "run", "--no-capture-output", "-n", "base", "/bin/bash", "-c"]
SHELL ["/bin/bash", "--login","-c"]
RUN cd ~ \
    && wget https://www.python.org/ftp/python/3.8.20/Python-3.8.20.tgz \
    && tar -xvf Python-3.8.20.tgz \
    && cd Python-3.8.20 \
    && ./configure --prefix=/usr/local/python3.8 \
    && make \
    && make install \
    && ln -s /usr/local/python3.8/bin/python3.8 /usr/bin/python3.8 \
    && ln -s /usr/local/python3.8/bin/pip3 /usr/bin/pip3.8 

RUN cd ~ \
    && git clone https://github.com/cquzys/SANGO.git \
    && cd SANGO \
    && pip3.8 install -r requirements.txt \
    && pip3.8 install torch_geometric \
    && pip3.8 install pyg_lib torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-1.13.1+cpu.html \
    && echo "alias SANGO_CACNN='python3.8 /root/SANGO/SANGO/CACNN/main.py '">> ~/.bashrc \
    && echo "alias SANGO_ANNOTATE='python3.8 /root/SANGO/SANGO/GraphTransformer/main.py '">> ~/.bashrc 

RUN cd ~ \
    && wget -O cellranger-atac-2.1.0.tar.gz "https://cf.10xgenomics.com/releases/cell-atac/cellranger-atac-2.1.0.tar.gz?Expires=1729582253&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1hdGFjL2NlbGxyYW5nZXItYXRhYy0yLjEuMC50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3Mjk1ODIyNTN9fX1dfQ__&Signature=Nz~yRq02iBHMqAiZzWXAPPchPoIQywjqDNp7N709hgoRslsa6zganDyRUyIZLGurJ46kIxhRuxG4qlNdOGqPq8l2oKLiQyH9x03ET9SnBvJIxMtRRnyrrG0XkWIrVvun2c4aH5CjPboYISujXTNA6G6RD52NuDUe9PNZpUJUvEFABpNjCszRtOenyXO4tdBzXJzMvwyqMySf-gdd~Cdy3~IQ~SA6CjkGuX8x2d3sSAOlITYZ5t42Cly445KnO12y0eAhc23x~Q6m4jHFvXpU86S~d1D18PCWVY0c-ZLAGcj-dvk90jbRyQSJ8rQoPimeCi3Q6Yjdt9JtXyI8RD3s4A__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA" \
    && tar xzvf cellranger-atac-2.1.0.tar.gz \
    && rm -rf cellranger-atac-2.1.0.tar.gz \
    && mv cellranger-atac-2.1.0 /usr/local/bin/ \
    && ln -s /usr/local/bin/cellranger-atac-2.1.0/cellranger-atac /usr/local/bin/cellranger-atac \
    && rm -f /usr/local/bin/cellranger

RUN cd ~ \
    && wget -O cellranger-8.0.1.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-8.0.1.tar.gz?Expires=1729585805&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA&Signature=FATQruCKnXcCOrHeOGdIht~WMqYbpYVbA4sdwtKSEqeC7FRuBQgovaEdR1t03oKpRyIHrr4dqpZqY28s0qIwGhjvpsyU2H6yQVl4Qgu0OwXS1-Z~3En1wRCIA~wCHxn16XkQnSsgZ3A-Y4d0He1UGEKgXLmPCM-Mh8jHnjXH~GhV3tE18wDyGLy9FJZm6XOpAR8gAcAadefv18HEWRGh40ymBmY0ZZxRgdX7alIL5zaPS~cutoaY~T45R589~ZIIdQvELqFTq3xeOIMINzQwc1xSX7kxy3ePcZBAQFINigT8ja4lO4I-W6yOCfgfEswaL7ciiJT5MB3~2oVEZReQmQ__" \
    && tar xzvf cellranger-8.0.1.tar.gz \
    && rm -rf cellranger-8.0.1.tar.gz \
    && mv cellranger-8.0.1 /usr/local/bin/ \
    && ln -s /usr/local/bin/cellranger-8.0.1/cellranger /usr/local/bin/cellranger

SHELL ["/bin/bash", "-c"]

EXPOSE 8888
ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["/bin/bash"]