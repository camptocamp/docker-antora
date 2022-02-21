FROM docker.io/antora/antora:3.0.1

RUN yarn global add \
    	@antora/lunr-extension@1.0.0-alpha.5 \
    	asciidoctor-kroki@0.15.4
RUN apk --no-cache add \
    	make
