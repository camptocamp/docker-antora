FROM docker.io/antora/antora:3.1.0

RUN yarn global add \
    	@antora/lunr-extension@1.0.0-alpha.8 \
    	asciidoctor-kroki@0.16
