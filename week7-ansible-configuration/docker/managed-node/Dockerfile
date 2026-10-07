FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        openssh-server \
        procps \
        python3 \
        sudo \
    && rm -rf /var/lib/apt/lists/*

RUN useradd \
        --create-home \
        --shell /bin/bash \
        ansible \
    && echo "ansible ALL=(ALL) NOPASSWD:ALL" \
        > /etc/sudoers.d/ansible \
    && chmod 0440 /etc/sudoers.d/ansible \
    && mkdir -p /run/sshd /home/ansible/.ssh \
    && chown -R ansible:ansible /home/ansible/.ssh \
    && chmod 0700 /home/ansible/.ssh

COPY --chown=ansible:ansible \
    keys/ansible.pub \
    /home/ansible/.ssh/authorized_keys

RUN chmod 0600 /home/ansible/.ssh/authorized_keys \
    && printf '%s\n' \
        'PasswordAuthentication no' \
        'PermitRootLogin no' \
        'PubkeyAuthentication yes' \
        > /etc/ssh/sshd_config.d/ansible-lab.conf

EXPOSE 22 80

CMD ["/usr/sbin/sshd", "-D", "-e"]
