FROM alpine

LABEL name=perl6-examples

# change the version based on version from perl6 download page
ARG rakudo_version=2019.03
ENV rakudo_version=${rakudo_version}

# install base package & mojolicious
RUN apk --update --no-cache add build-base curl wget gcc perl make git vim perl-io-socket-ssl perl-dbd-pg perl-dev g++ && \
    curl -L https://cpanmin.us | perl - -M https://cpan.metacpan.org -n Mojolicious      

# Download & install perl6 (like to try directly from rakudo-perl image)
RUN curl -O https://rakudostar.com/files/star/rakudo-star-${rakudo_version}.tar.gz && \
    tar xfz rakudo-star-2019.03.tar.gz && \
    cd rakudo-star-2019.03 && perl Configure.pl --gen-moar --make-install --prefix=/usr 

# Perl6-Examples clone repo & tried to install dependencies of it
RUN mkdir -p /opt/perl6-examples && mkdir -p /opt/zef 
RUN git clone https://github.com/perl6/perl6-examples /opt/perl6-examples && \
    git clone https://github.com/ugexe/zef /opt/zef && \
    cd /opt/zef && perl6 -I. bin/zef install . 

ENV PATH=$PATH:/usr/share/perl6/site/bin

# Running the make html / perl6 htmlify.pl process take around 1-2 hour in my box
RUN cd /opt/perl6-examples && zef --/test --test-depends --depsonly install . && make html 
#RUN cd /opt/perl6-examples && make html

EXPOSE 3000

ENTRYPOINT perl /opt/perl6-examples/app.pl daemon 
