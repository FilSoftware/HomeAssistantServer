ARG BUILD_FROM=hassioaddons/base:latest
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/ash", "-o", "pipefail", "-c"]

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

#ARG BUILD_FROM
#FROM $BUILD_FROM

#ENV LANG C.UTF-8

RUN \
	apk add icu \
	\
	&& apk add zlib \
	\
	&& apk add curl \
	\
	&& apk add libcurl \
	\
	&& apk add libintl 

RUN 	apk add openssh

RUN 	mkdir -p /run/nginx \
	\
	&& apk add nginx \
	\
	&& echo "daemon off;" >> /etc/nginx/nginx.conf
	#\
	#&& echo "https://nginx.org/packages/mainline/alpine/v3.12/main/$basearch/" >> /etc/apk/repositories

COPY rootfs /

COPY dotnet-install.sh /usr

RUN chmod +x /usr/dotnet-install.sh

RUN /usr/dotnet-install.sh --runtime aspnetcore 

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]