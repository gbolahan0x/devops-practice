FROM alpine:3.21

RUN apk add --no-cache bash py3-pip \
    && pip install --no-cache-dir --break-system-packages yamllint

WORKDIR /workspace

COPY templates/ ./templates/
COPY scripts/ ./scripts/

RUN chmod +x ./scripts/*.sh

ENTRYPOINT ["bash"]
