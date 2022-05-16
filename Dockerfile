FROM rpy2/jupyter
LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"

COPY dependencies.sys requirements.txt packages.R /tmp/

ENV SHELL=/bin/bash
USER root

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN sed -i -e 's|disco|focal|g' /etc/apt/sources.list
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" >> /etc/apt/sources.list
RUN apt-get update
RUN xargs apt-get -y --no-install-recommends install < /tmp/dependencies.sys 
RUN apt-get clean 
RUN apt-get autoremove 
RUN rm -rf /var/lib/apt/lists/* 
RUN pip3 install pandas --no-cache-dir

RUN R -f /tmp/packages.R

EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["/init"]
