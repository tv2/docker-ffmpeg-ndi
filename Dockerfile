FROM	ubuntu:16.04 AS base

WORKDIR	/

# CleanUp Ubuntu
RUN		apt-get -yqq update && \
		apt-get install -yq --no-install-recommends ca-certificates expat libgomp1 && \
		apt-get autoremove -y && \
		apt-get clean -y

FROM	base AS build

# Environment
ENV		PKG_CONFIG_PATH=/ffmpeg_build/ffmpeg/lib/pkgconfig

# Build dependencies:
RUN		buildDeps="autoconf \
					automake \
					build-essential \
					cmake \
					git \
					libass-dev \
					libfreetype6-dev \
					libtheora-dev \
					libtool \
					libvorbis-dev \
					mercurial \
					pkg-config \
					texinfo \
					wget \
					zlib1g-dev \
					yasm \
					libx264-dev \
					libx265-dev \
					libvpx-dev \
					libfdk-aac-dev \
					libmp3lame-dev \
					libopus-dev \
					v4l-utils \
					v4l2loopback-dkms \
					libsdl2-dev \
					libtheora-dev \
					libtool \
					libva-dev \
					libvdpau-dev \
					libvorbis-dev \
					libxcb1-dev \
					libxcb-shm0-dev \
					libxcb-xfixes0-dev \
					libopencore-amrnb-dev \
					libopencore-amrwb-dev \
					librtmp-dev \
					curl \
					bzip2 \
					libexpat1-dev \
					g++ \
					gcc \
					gperf \
					libtool \
					make \
					nasm \
					perl \
					pkg-config \
					python \
					avahi-daemon \
					avahi-utils \
					libnss-mdns \
					libssl-dev" && \
					apt-get -yqq update && \
					apt-get install -yq --no-install-recommends ${buildDeps}

# Prepare build sources, build and lib folders:
WORKDIR	"ffmpeg_build/lib/pkgconfig"

# Install NDI SDK
WORKDIR	"/ndi"
COPY	InstallNDISDK_v3_Linux.sh .
RUN		chmod +x InstallNDISDK_v3_Linux.sh
RUN		./InstallNDISDK_v3_Linux.sh 

# ToDo..... mv rename file to underscore: (find fix for this workaround)
RUN		mv NDI\ SDK\ for\ Linux NDI_SDK_for_Linux

# Put NDI lib ref text into conf file
RUN		echo "/ndi/NDI_SDK_for_Linux/lib/x86_64-linux-gnu" >> /etc/ld.so.conf.d/ndi.conf
RUN		ldconfig

# Fetch FFmpeg:
WORKDIR	"/ffmpeg_sources"
RUN		wget -O ffmpeg-4.1.1.tar.bz2 http://ffmpeg.org/releases/ffmpeg-4.1.1.tar.bz2 && \
		tar xjvf ffmpeg-4.1.1.tar.bz2
RUN		mv ffmpeg-4.1.1 ffmpeg

# Compile FFmpeg:
WORKDIR	"/ffmpeg_sources/ffmpeg"
RUN		./configure \
			--prefix="/ffmpeg_build" \
			--pkg-config-flags="--static" \
			--extra-cflags="-I/ndi/NDI_SDK_for_Linux/include" \
			--extra-ldflags="-L/ndi/NDI_SDK_for_Linux/lib/x86_64-linux-gnu" \
			--bindir="/bin" \
			--enable-gpl \
			--enable-libass \
			--enable-libfdk-aac \
			--enable-libfreetype \
			--enable-libmp3lame \
			--enable-libopencore-amrnb \
			--enable-libopencore-amrwb \
			--enable-librtmp \
			--enable-libopus \
			--enable-libtheora \
			--enable-libvorbis \
			--enable-libvpx \
			--enable-libx264 \
			--enable-nonfree \
			--enable-version3 \
			--enable-libndi_newtek \
			--enable-libxcb \
			--disable-decklink

RUN		make
RUN		make install


#KAOL Remove restriction in Avahi - put a # in front of rlimit-nproc=3
#RUN sed -i '/rlimit-nproc/s/^/#/' /etc/avahi/avahi-daemon.conf

#Start Dbus & Avahi to handle mDNS
RUN     update-rc.d dbus defaults
RUN     update-rc.d avahi-daemon defaults

# Cleanup 
RUN     mv /ffmpeg_sources/ffmpeg/ffmpeg /usr/local/ffmpeg
RUN     rm /ndi/InstallNDISDK_v3_Linux.sh


#For network testing ------ KAOL uncomment to test
RUN     apt-get install -yq --no-install-recommends net-tools iputils-ping

#ADD Avahi script for running Daemon on startup
ADD     "start.sh" "/root/start.sh"
RUN     chmod +x /root/start.sh

#Make User - to be able to run Avahi:
#RUN useradd -r -u 1901 dockeruser
#USER dockeruser

ENTRYPOINT  ["/root/start.sh"]
ENV         LD_LIBRARY_PATH=/usr/local/lib

EXPOSE      5000-6000/udp
EXPOSE      5000-6000
