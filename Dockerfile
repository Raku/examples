# building base alpine + install the perl6 from repository rakudo-pkg
FROM alpine:3.10 as base
RUN apk add --update --no-cache build-base wget git curl vim \
    && wget https://github.com/nxadm/rakudo-pkg/releases/download/v2020.01/rakudo-pkg-Alpine3.10_2020.01-01_x86_64.apk && \
    apk add --allow-untrusted rakudo-pkg-Alpine3.10_2020.01-01_x86_64.apk

ENV PATH=$PATH:/opt/rakudo-pkg/bin

RUN mkdir -p /opt/perl6-examples \ && git clone https://github.com/perl6/perl6-examples /opt/perl6-examples \
    && cd /opt/perl6-examples && zef --/test --test-depends --depsonly install . && make html

# running daemon perl6-examples 
FROM alpine:3.10
RUN apk add perl perl-mojolicious
COPY --from=base /opt/perl6-examples /opt
EXPOSE 3000
CMD cd /opt && perl app.pl daemon
