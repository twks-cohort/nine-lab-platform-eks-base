ARG TF_VERSION=1.3.3
ARG USERNAME=cohorts-nine
ARG USER_GID=1001


FROM python:3.8-alpine AS awscli

ENV AWSCLI_VERSION=2.11.8

RUN apk add --no-cache \
    curl \
    make \
    cmake \
    gcc \
    g++ \
    libc-dev \
    libffi-dev \
    openssl-dev \
    && curl https://awscli.amazonaws.com/awscli-${AWSCLI_VERSION}.tar.gz | tar -xz \
    && cd awscli-${AWSCLI_VERSION} \
    && ./configure --prefix=/opt/aws-cli/ --with-download-deps \
    && make \
    && make install


FROM hashicorp/terraform:$TF_VERSION as terraform

ARG TF_VERSION
ARG CONTAINER_NAME

LABEL name="$CONTAINER_NAME"

ENV TF_VERSION=$TF_VERSION

FROM python:3.8-alpine

ARG USERNAME
ARG USER_UID
ARG USER_GID

RUN apk --no-cache add groff make bash curl git

COPY --from=awscli /opt/aws-cli/ /opt/aws-cli/
COPY --from=terraform /bin/terraform /bin/terraform
RUN ln -s /opt/aws-cli/bin/aws /usr/bin/aws

COPY . /app
WORKDIR /app

RUN addgroup -g $USER_GID $USERNAME \
    && adduser -D -u $USER_UID -G $USERNAME $USERNAME 

USER $USERNAME

# Test binaries
RUN set -eux \
    && terraform --version \
    && aws --version

ENTRYPOINT [ "make" ]
