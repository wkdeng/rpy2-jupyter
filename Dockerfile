FROM ubuntu:Jammy
LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"


###### Install rpy2 (Credit: github.com/rpy2/rpy2-docker) ######
ARG DEBIAN_FRONTEND=noninteractive
ENV CRAN_MIRROR=https://cloud.r-project.org \
    CRAN_MIRROR_TAG=-cran40

ARG RPY2_VERSION=RELEASE_3_5_6
ARG RPY2_CFFI_MODE=BOTH

COPY install_apt.sh /opt/
COPY install_rpacks.sh /opt/
COPY install_pip.sh /opt/

RUN \
  sh /opt/install_apt.sh \
  && sh /opt/install_rpacks.sh \
  && sh /opt/install_pip.sh \
  && rm -rf /tmp/* \
  && apt-get remove --purge -y $BUILDDEPS \
  && apt-get autoremove -y \
  && apt-get autoclean -y \
  && rm -rf /var/lib/apt/lists/*

RUN \
  python3 -m pip --no-cache-dir install https://github.com/rpy2/rpy2/archive/"${RPY2_VERSION}".zip && \
  rm -rf /root/.cache

###### Install Jupyter (Credit: github.com/rpy2/rpy2-docker) ######


ARG RPY2_VERSION=master
ARG DEBIAN_FRONTEND=noninteractive
ENV JUPYTER_ENABLE_LAB=1
ARG TINI_VERSION=v3.0.1
ENV SHELL=/bin/bash \
    NB_USER=jupyteruser \
    NB_UID=1000

USER root

COPY install_jupyter.sh /opt/install_jupyter.sh
COPY setup_jupyter.sh /opt/setup_jupyter.sh

RUN \
  apt-get update -qq \
  && apt-get install -y curl \
  && apt-get remove -y --purge nodejs npm \
  && curl -sL https://deb.nodesource.com/setup_17.x | sudo -E bash - \
  && apt-get install -y nodejs \
  && wget -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && apt-get update -qq \
  && apt-get install -y yarn \
  && npm install -g configurable-http-proxy \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m -s /bin/bash -N -u "${NB_UID}" "${NB_USER}" \
  && sh /opt/install_jupyter.sh \
  && echo "${NB_USER}" 'ALL=(ALL) NOPASSWD: /usr/bin/apt-get' >> /etc/sudoers \
  && wget --quiet https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini \
      -P /usr/local/bin/ \
  && chmod +x /usr/local/bin/tini \
  && sh /opt/setup_jupyter.sh \
  && echo "Add Jupyter scripts emerging as ad hoc interface" \
  && git clone --depth=1 https://github.com/jupyter/docker-stacks.git /tmp/docker-stacks \
  && cd /tmp/docker-stacks/base-notebook \
  && sed -e 's/jovyan/'"${NB_USER}"'/g' start.sh > /usr/local/bin/start.sh \
  && cp start-notebook.sh /usr/local/bin/ \
  && cp start-singleuser.sh /usr/local/bin/ \
  && mkdir -p /etc/jupyter/ \
  && cp jupyter_notebook_config.py /etc/jupyter/ \
  && rm -rf /tmp/docker-stacks


###### Install required packages ######
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
RUN pip3 install -r /tmp/requirements --no-cache-dir


RUN R -f /tmp/packages.R

EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["/init"]
