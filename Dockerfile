FROM bash:5 AS pandoc-downloader

ARG PANDOC_VERSION=2.17.1.1
ARG PANDOC_CHECKSUM=bce0609dfe196784fe0300fb6847a2a246391a5b98e0490e5f7eadb78afb0d74

WORKDIR /workspace
RUN wget -qO pandoc.tar.gz https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz \
 && echo "${PANDOC_CHECKSUM}  pandoc.tar.gz" | sha256sum -sc \
 && tar --no-same-owner --strip-components 1 -xzf pandoc.tar.gz \
 && rm pandoc.tar.gz


FROM bash:5 AS terraform-docs-downloader

ARG TERRAFORM_DOCS_VERSION=0.16.0
ARG TERRAFORM_DOCS_CHECKSUM=328c16cd6552b3b5c4686b8d945a2e2e18d2b8145b6b66129cd5491840010182

WORKDIR /workspace
RUN wget -qO terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz \
 && echo "${TERRAFORM_DOCS_CHECKSUM}  terraform-docs.tar.gz" | sha256sum -sc \
 && tar --no-same-owner -xzf terraform-docs.tar.gz \
 && rm terraform-docs.tar.gz


FROM bash:5 AS helm-docs-downloader

ARG HELM_DOCS_VERSION=1.7.0
ARG HELM_DOCS_CHECKSUM=b39ad34acd03256317692e5c671847d6f12bcd6c92adf05b3df83363d1dac20f

WORKDIR /workspace
RUN wget -qO helm-docs.tar.gz https://github.com/norwoodj/helm-docs/releases/download/v${HELM_DOCS_VERSION}/helm-docs_${HELM_DOCS_VERSION}_Linux_x86_64.tar.gz \
 && echo "${HELM_DOCS_CHECKSUM}  helm-docs.tar.gz" | sha256sum -sc \
 && tar --no-same-owner -xzf helm-docs.tar.gz \
 && rm helm-docs.tar.gz


FROM docker.io/antora/antora:3.0.1

RUN yarn global add \
    	@antora/lunr-extension@1.0.0-alpha.5 \
    	asciidoctor-kroki@0.15.4
RUN apk --no-cache add \
    	make
COPY --from=pandoc-downloader /workspace/bin/pandoc /usr/local/bin/
COPY --from=terraform-docs-downloader /workspace/terraform-docs /usr/local/bin/
COPY --from=helm-docs-downloader /workspace/helm-docs /usr/local/bin/
