FROM rpy2/jupyter
LABEL maintainer="Wankun Deng <dengwankun@gmail.com>"

COPY dependencies.sys requirements.txt packages.R /tmp/

ENV SHELL=/bin/bash
USER root


RUN apt-get update -qq \
  && xargs apt-get -y --no-install-recommends install < /tmp/dependencies.sys \
  && apt-get clean \
  && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && pip install -r /tmp/requirements.txt --no-cache-dir

RUN R -f /tmp/packages.R

EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["start-notebook.sh"]
