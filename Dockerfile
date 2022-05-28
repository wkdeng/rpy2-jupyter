# FROM ubuntu:jammy
# LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"


# # ###### Install rpy2 (Modified from: github.com/rpy2/rpy2-docker) ######
# ARG DEBIAN_FRONTEND=noninteractive
# ENV CRAN_MIRROR=https://cloud.r-project.org \
#     CRAN_MIRROR_TAG=-cran40

# ARG RPY2_VERSION=RELEASE_3_5_1
# ARG RPY2_CFFI_MODE=BOTH

# COPY install_apt.sh /opt/
# COPY install_rpacks.sh /opt/
# COPY install_pip.sh /opt/

# RUN \
#     sh /opt/install_apt.sh \
#     && sh /opt/install_rpacks.sh \
#     && sh /opt/install_pip.sh \
#     && rm -rf /tmp/* \
#     && apt-get remove --purge -y $BUILDDEPS \
#     && apt-get autoremove -y \
#     && apt-get autoclean -y \
#     && rm -rf /var/lib/apt/lists/* \
#     && python3 -m pip --no-cache-dir install https://github.com/rpy2/rpy2/archive/"${RPY2_VERSION}".zip \
#     && rm -rf /root/.cache


# # ###### Install Jupyter (Modified from: github.com/rpy2/rpy2-docker) ######
# # FROM dengwankun/bioinfo_env:rpy2_base
# # LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"

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

# RUN apt-get update -qq \
#     && apt-get install -y curl  \
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
#     && wget --quiet https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini -P /usr/local/bin/ \
#     && chmod +x /usr/local/bin/tini \
#     && sh /opt/setup_jupyter.sh \
#     && echo "Add Jupyter scripts emerging as ad hoc interface" \
#     && git clone --depth=1 https://github.com/jupyter/docker-stacks.git /tmp/docker-stacks \
#     && cd /tmp/docker-stacks/base-notebook \
#     && rm -rf /tmp/docker-stacks


# ###### Install required packages ######
FROM dengwankun/bioinfo_env:jpt_base
LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"
COPY dependencies.sys requirements.txt packages.R /tmp/
ENV SHELL=/bin/bash
USER root

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
    && sed -i -e 's|disco|focal|g' /etc/apt/sources.list \
    && echo "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" >> /etc/apt/sources.list \
    && apt-get update -qq \
    && xargs apt-get -y --no-install-recommends install < /tmp/dependencies.sys \
    && apt-get clean \
    && apt-get autoremove \ 
    && rm -rf /var/lib/apt/lists/* 
    # && pip3 install -r /tmp/requirements.txt --no-cache-dir \
    # && jt -t monokai -f fira -fs 10 -nf ptsans -nfs 11 -N -kl -cursw 2 -cursc r -cellw 95% -T \
    # && jupyter labextension install @jupyterlab/toc \
    # && R -f /tmp/packages.R

RUN pip3 install --no-cache-dir scipy
RUN pip3 install --no-cache-dir statistics
# RUN pip3 install --no-cache-dir pandas 
RUN pip3 install --no-cache-dir statsmodels
RUN pip3 install --no-cache-dir pybedtools
RUN pip3 install --no-cache-dir sklearn
RUN pip3 install --no-cache-dir scikit-learn
RUN pip3 install --no-cache-dir snakemake
RUN pip3 install --no-cache-dir matplotlib
RUN pip3 install --no-cache-dir mappy
# RUN pip3 install --no-cache-dir pyVCF
RUN pip3 install --no-cache-dir cutadapt
RUN pip3 install --no-cache-dir pyBigWig
RUN pip3 install --no-cache-dir pysam
RUN pip3 install --no-cache-dir PyYAML
RUN pip3 install --no-cache-dir numpy --upgrade --force-reinstall
RUN pip3 install --no-cache-dir umap-learn
RUN pip3 install --no-cache-dir jupyterthemes
# RUN pip3 install -r /tmp/requirements.txt --no-cache-dir
RUN jt -t monokai -f fira -fs 10 -nf ptsans -nfs 11 -N -kl -cursw 2 -cursc r -cellw 95% -T 
RUN jupyter labextension install @jupyterlab/toc 
# RUN R -f /tmp/packages.R

EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["/init"]
