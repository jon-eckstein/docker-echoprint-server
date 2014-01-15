FROM base:ubuntu-12.10
MAINTAINER Jon Eckstein <jon.eckstein@gmail.com>

# Install dependencies
RUN apt-get update
RUN apt-get install -y build-essential python git zlib1g-dev libbz2-dev wget

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

#Execute the Tokyo suite
RUN /usr/local/tokyotyrant-1.1.33/bin/ttserver &

# Install Java 7
RUN apt-get install software-properties-common -y
RUN apt-add-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install oracle-java7-installer -y

#Install Echoprint server
RUN git clone git://github.com/echonest/echoprint-server.git echoprint-server

#Setup web.py
RUN apt-get install -y python-setuptools
RUN easy_install web.py
RUN easy_install pyechonest

#Start Solr
#RUN cd echoprint-server/solr/solr && java -jar -Dsolr.solr.home=/echoprint-server/solr/solr/solr/ -Djava.awt.headless=true start.jar 2>&1 > /dev/null &
RUN python /echoprint-server/API/api.py 8555 &

EXPOSE 8555 
EXPOSE 8502

#CMD java -Dsolr.solr.home=/echoprint-server/solr/solr/solr/ -Djava.awt.headless=true echoprint-server/solr/solr/start.jar 2>&1 > /dev/null & && sudo python echoprint-server/API/api.py 8555
CMD cd echoprint-server/solr/solr && java -jar -Dsolr.solr.home=/echoprint-server/solr/solr/solr/ -Djava.awt.headless=true start.jar
#CMD ["sudo","python", "echoprint-server/API/api.py", "8555"]
#CMD sudo python /echoprint-server/API/api.py 8555
#CMD python /echoprint-server/API/api.py 8555 & && cd echoprint-server/solr/solr && java -jar -Dsolr.solr.home=/echoprint-server/solr/solr/solr/ -Djava.awt.headless=true start.jar
