# FROM ubuntu:jammy
# LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"


# ###### Install rpy2 (Credit: github.com/rpy2/rpy2-docker) ######
# ARG DEBIAN_FRONTEND=noninteractive
# ENV CRAN_MIRROR=https://cloud.r-project.org \
#     CRAN_MIRROR_TAG=-cran40

# ARG RPY2_VERSION=RELEASE_3_5_1
# ARG RPY2_CFFI_MODE=BOTH

# COPY install_apt.sh /opt/
# COPY install_rpacks.sh /opt/
# COPY install_pip.sh /opt/

# RUN \
#   sh /opt/install_apt.sh \
#   && sh /opt/install_rpacks.sh \
#   && sh /opt/install_pip.sh \
#   && rm -rf /tmp/* \
#   && apt-get remove --purge -y $BUILDDEPS \
#   && apt-get autoremove -y \
#   && apt-get autoclean -y \
#   && rm -rf /var/lib/apt/lists/*

# RUN python3 -m pip --no-cache-dir install https://github.com/rpy2/rpy2/archive/"${RPY2_VERSION}".zip 
# RUN rm -rf /root/.cache


###### Install Jupyter (Credit: github.com/rpy2/rpy2-docker) ######
# FROM dengwankun/bioinfo_env:rpy2_base
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

# RUN apt-get update -qq
# RUN apt-get install -y curl 
# RUN apt-get remove -y --purge nodejs npm 
# RUN chmod +x /opt/install_nodejs_npm.sh && /opt/install_nodejs_npm.sh
# # RUN wget -qO- https://deb.nodesource.com/setup_17.x | bash -
# RUN apt-get install -y nodejs 
# RUN wget -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - 
# RUN apt-get update -qq 
# RUN apt-get install -y yarn 
# RUN npm install -g configurable-http-proxy 
# RUN rm -rf /var/lib/apt/lists/* 
# RUN useradd -m -s /bin/bash -N -u "${NB_UID}" "${NB_USER}" 
# RUN sh /opt/install_jupyter.sh
# RUN echo "${NB_USER}" 'ALL=(ALL) NOPASSWD: /usr/bin/apt-get' >> /etc/sudoers
# RUN wget --quiet https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini -P /usr/local/bin/
# RUN chmod +x /usr/local/bin/tini
# RUN sh /opt/setup_jupyter.sh
# RUN echo "Add Jupyter scripts emerging as ad hoc interface"
# RUN git clone --depth=1 https://github.com/jupyter/docker-stacks.git /tmp/docker-stacks
# RUN cd /tmp/docker-stacks/base-notebook
# # RUN sed -e 's/jovyan/'"${NB_USER}"'/g' start.sh > /usr/local/bin/start.sh
# # RUN cp start-notebook.sh /usr/local/bin/
# # RUN cp start-singleuser.sh /usr/local/bin/
# # RUN mkdir -p /etc/jupyter/
# # RUN cp jupyter_notebook_config.py /etc/jupyter/
# RUN rm -rf /tmp/docker-stacks




# ###### Install required packages ######
FROM dengwankun/bioinfo_env:jpt_base
LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"
COPY dependencies.sys requirements.txt packages.R /tmp/
ENV SHELL=/bin/bash
USER root

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN sed -i -e 's|disco|focal|g' /etc/apt/sources.list
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" >> /etc/apt/sources.list
RUN apt-get update -qq
RUN xargs apt-get -y --no-install-recommends install < /tmp/dependencies.sys 
RUN apt-get clean 
RUN apt-get autoremove 
RUN rm -rf /var/lib/apt/lists/* 

RUN pip3 install --no-cache-dir scipy
RUN pip3 install --no-cache-dir statistics
RUN pip3 install --no-cache-dir numpy 
RUN pip3 install --no-cache-dir pandas 
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
RUN pip3 install --no-cache-dir umap



# RUN pip3 install -r /tmp/requirements.txt --no-cache-dir --user

RUN R -f /tmp/packages.R

EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["/init"]
