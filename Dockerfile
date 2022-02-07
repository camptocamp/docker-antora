FROM docker.io/antora/antora:3.0.1

RUN yarn global add @antora/lunr-extension asciidoctor-kroki
