FROM bash:5 AS pandoc-downloader

ARG PANDOC_VERSION=2.17.1.1
ARG PANDOC_CHECKSUM=bce0609dfe196784fe0300fb6847a2a246391a5b98e0490e5f7eadb78afb0d74

WORKDIR /workspace
RUN wget -qO pandoc.tar.gz https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz \
 && echo "${PANDOC_CHECKSUM}  pandoc.tar.gz" | sha256sum -sc \
 && tar --no-same-owner --strip-components 1 -xzf pandoc.tar.gz \
 && rm pandoc.tar.gz


FROM docker.io/antora/antora:3.0.1

RUN yarn global add \
    	@antora/lunr-extension@1.0.0-alpha.5 \
    	asciidoctor-kroki@0.15.4
RUN apk --no-cache add \
    	make
COPY --from=pandoc-downloader /workspace/bin/pandoc /usr/local/bin/
