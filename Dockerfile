# get minimal perl from standard docker image 
FROM perl:5.20 AS perlrun
RUN curl -L https://cpanmin.us | perl - -M https://cpan.metacpan.org -n Mojolicious 

# building base alpine + install the perl6 from repository rakudo-pkg
FROM alpine:3.10 as base
RUN apk add --update --no-cache build-base wget git curl \
    && wget https://github.com/nxadm/rakudo-pkg/releases/download/v2019.07/rakudo-pkg-Alpine3.10_2019.07-01_x86_64.apk && \
    apk add --allow-untrusted rakudo-pkg-Alpine3.10_2019.07-01_x86_64.apk 

ENV PATH=$PATH:/opt/rakudo-pkg/bin

RUN mkdir -p /opt/perl6-examples \ && git clone https://github.com/perl6/perl6-examples /opt/perl6-examples \
    && cd /opt/perl6-examples && zef --/test --test-depends --depsonly install . && make html

# running daemon perl6-examples 
FROM perlrun as release
COPY --from=base /opt/perl6-examples/ /opt/
EXPOSE 3000
CMD perl /opt/app.pl daemon