FROM ubuntu:12.04
MAINTAINER Jon Eckstein <jon.eckstein@gmail.com>

#Update
RUN apt-get update

# Install dependencies
RUN apt-get install -y build-essential python git zlib1g-dev libbz2-dev wget supervisor
RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install tokyo cabinet
RUN wget http://sourceforge.net/projects/tokyocabinet/files/tokyocabinet/1.4.32/tokyocabinet-1.4.32.tar.gz
RUN tar xvf tokyocabinet-1.4.32.tar.gz
RUN mkdir /usr/local/tokyocabinet-1.4.32/
RUN cd tokyocabinet-1.4.32 && ./configure --prefix=/usr/local/tokyocabinet-1.4.32/ && make && make install

# Install Tokyo Tyrant
RUN wget http://sourceforge.net/projects/tokyocabinet/files/tokyotyrant/1.1.33/tokyotyrant-1.1.33.tar.gz
RUN tar xvf tokyotyrant-1.1.33.tar.gz
RUN mkdir /usr/local/tokyotyrant-1.1.33
RUN cd tokyotyrant-1.1.33 && ./configure --prefix=/usr/local/tokyotyrant-1.1.33/ --with-tc=/usr/local/tokyocabinet-1.4.32/ && make && make install

RUN cd /usr/local/tokyotyrant-1.1.33/ && ln -s /usr/local/tokyocabinet-1.4.32/lib/libtokyocabinet.so.8 lib/

# Install Java 7
RUN apt-get install python-software-properties -y
RUN apt-get install software-properties-common -y
RUN apt-add-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install oracle-java7-installer -y

#Install Echoprint server
RUN git clone git://github.com/echonest/echoprint-server.git echoprint-server

#Setup web.py
RUN apt-get install -y python-setuptools
RUN easy_install web.py
RUN easy_install pyechonest

EXPOSE 8555 
EXPOSE 8502

CMD ["/usr/bin/supervisord"]
