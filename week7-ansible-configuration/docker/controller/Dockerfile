FROM python:3.13-slim

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        openssh-client \
    && pip install --no-cache-dir \
        "ansible-core>=2.21,<2.22" \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/.ssh \
    && chmod 0700 /root/.ssh

WORKDIR /workspace

CMD ["ansible", "--version"]
