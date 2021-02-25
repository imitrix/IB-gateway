FROM ubuntu:20.10

COPY scripts/install-packages.sh .
RUN chmod -R u+x install-packages.sh
RUN ./install-packages.sh

# Set env vars for IBG/IBC
ENV IBG_VERSION=981-latest \
IBC_VERSION=3.8.5 \
IBC_INI=/root/config.ini \
IBC_PATH=/opt/ibc \
TWS_PATH=/root/Jts \
TWS_CONFIG_PATH=/root/Jts \
LOG_PATH=/opt/ibc/logs

# Install IBG
RUN curl --fail --output /tmp/ibgateway-standalone-linux-x64.sh https://s3.amazonaws.com/ib-gateway/ibgateway-${IBG_VERSION}-standalone-linux-x64.sh \
	&& chmod u+x /tmp/ibgateway-standalone-linux-x64.sh \
	&& echo '\n' | sh /tmp/ibgateway-standalone-linux-x64.sh \ 
	&& rm -f /tmp/ibgateway-standalone-linux-x64.sh

# Install IBC
RUN curl --fail --silent --location --output /tmp/IBC.zip https://github.com/ibcalpha/ibc/releases/download/${IBC_VERSION}/IBCLinux-${IBC_VERSION}.zip \
	&& unzip /tmp/IBC.zip -d ${IBC_PATH} \
	&& chmod -R u+x ${IBC_PATH}/*.sh \
	&& chmod -R u+x ${IBC_PATH}/scripts/*.sh \
	&& apt-get remove -y unzip \
	&& rm -f /tmp/IBC.zip

# Install ib_insync
RUN pip install ib_insync \
	&& pip install psutil \
	&& apt-get remove -y git
  
WORKDIR /

ENV DISPLAY :0

ADD ./vnc/xvfb_init /etc/init.d/xvfb
ADD ./vnc/vnc_init /etc/init.d/vnc
ADD ./vnc/xvfb-daemon-run /usr/bin/xvfb-daemon-run

# expose ibg and vnc port
EXPOSE 4001


RUN chmod -R u+x runscript.sh \
  && chmod -R 777 /usr/bin/xvfb-daemon-run \
  && chmod 777 /etc/init.d/xvfb \
  && chmod 777 /etc/init.d/vnc

RUN dos2unix /usr/bin/xvfb-daemon-run \
  && dos2unix /etc/init.d/xvfb \
  && dos2unix /etc/init.d/vnc \
  && dos2unix runscript.sh

# Below files copied during build to enable operation without volume mount
#COPY ./ib/IBController.ini /root/IBController/IBController.ini
COPY ./ib/jts.ini /root/Jts/jts.ini
COPY scripts/runscript.sh .
COPY scripts /root/scripts
#RUN chmod u+x /etc/init.d/* \#
#	#&& chmod u+x /root/*

CMD bash runscript.sh
