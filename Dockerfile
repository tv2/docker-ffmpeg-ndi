FROM	ubuntu:16.04 AS base

WORKDIR	/

# CleanUp Ubuntu
RUN	apt-get -yqq update && \
	apt-get install -yq --no-install-recommends ca-certificates expat libgomp1 curl && \
	apt-get autoremove -y && \
	apt-get clean -y

FROM	base AS ndi
ENV	DEBIAN_FRONTEND noninteractive

# Install NDI SDK
WORKDIR "/ndi"
#COPY	InstallNDISDK_v3_Linux.sh .
#RUN	curl 'https://public.ph.files.1drv.com/y4mfVSdmdR1v_I4dHNqpvVaFoKHjSASNGRIT80Ep5PllUUuhJsPB292_tg54czKkBkhrHO67H_9SCnevB3mc41R5_Vfbt39_6cNIZ2roK0xuYYkqw4bhuGBLS-XceREfm_eAL3QF0S7lJdG2iML9YR7e9y1DtkdnrRjeW0KdPiG8t905dM6aPk1GTdW1krCUdW9NbhSZvalLl2NSe45vbCiUHc9GfDjaB9V-vnLPn3ZFog?AVOverride=1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/115.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Connection: keep-alive' -H 'Referer: https://onedrive.live.com/' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: iframe' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: cross-site' -H 'TE: trailers' --output Install_NDI_SDK_v5_Linux.tar.gz
#RUN	tar -xvzf Install_NDI_SDK_v5_Linux.tar.gz
RUN	curl 'https://phx02pap004files.storage.live.com/y4m5JcPWap_6wjv2l6w9d-tKL2cy4kRGKoppyFZPl0ea5_wkOqwNwoPnjfkphi-ZmaodkqW0W576dk1-oze19Uq6EmPx9aDS9lqI795ZvhOypcravI5XVKr3gvOVlds9nI51DZGyLhX58Q_4sCaaKA2sbLiHdpyEh8WRecO5mAeopfUsey5jAIHI1W6ENCGc4y6?encodeFailures=1&width=1036&height=858' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/115.0' -H 'Accept: image/avif,image/webp,*/*' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Referer: https://onedrive.live.com/' -H 'Sec-Fetch-Dest: image' -H 'Sec-Fetch-Mode: no-cors' -H 'Sec-Fetch-Site: same-site' -H 'Connection: keep-alive' -H 'Cookie: E=P:57HRs9ST24g=:DdWxDnzTWUdYEyV2992ACQFzA/lkuDsXDZ8OuyCA6HY=:F; xid=9562969e-2d1e-451d-9a33-2f1c7026bd56&YtbmR&RD00155D74F311&259; xidseq=79; wla42=cGh4MDJwYXAwMDQqMSxDNkRDM0U0NDg5MzA1NjE0LDAsLDAsLTEsLTE=; SAToken0=; SAToken1=; wlidperf=latency=&throughput=; PPLState=1; MSPAuth=Disabled; MSPProf=Disabled; NAP=V=1.9&E=1c4c&C=75xVorKAjohSTNYzHTyPDT5o1vQF26umwzjGdPSoqg-pjkkqVW8L_A&W=1; ANON=A=B6092E9B1587D2ACCD1217D7FFFFFFFF&E=1ca6&W=1; WLSSC=EgAiAgMAAAAMgAAADwABBDRVi41t6wR55HmI0Tl2RMz91xUNzbBScIYh70YkvFORnvMhr02iGFkbWHLEJxu5zC0uOUr40cnNvAksQlnEI5KwQWvdxYgUbH3Df4gqQ1vF/vG84+PFhEppz9cAZgyNkdQ+DxvJB3u0MrIuL1xeNpqIq02II1cuad/s2jnSxU4kFOcOB+u7VeMM1jMDG/HRtosSrqdLJODqWNMANTPlaboaz28Jx1oUvK0CHlGYTFMKwQ2oXvh/zgSZxZ1k6SkcmD73Rfjdjy+aIfirFqwL7DjVV+atDhiW330EkGVvS8+JeXdtn9oLYH3wllsCy/EGiKeCia7eTharFKIk4FAzQhEBfgARAQAAAwC/M5KEJRLLZCMSy2QQJwAAChCggBARAGtzZW50aUBnbWFpbC5jb20AWgAAHWtzZW50aSVnbWFpbC5jb21AcGFzc3BvcnQuY29tAAAEXlVTAAU3MzAzNAAAXuUECQIAAHb4VUAQBkEABUtlaXRoAAVTZW50aQAAAAAAAAAAAAAAAAAAAAMAAIkwVhTG3D5EAAAlEstkI7lBZQAAAAAAAAAAAAAAAA4AOTkuNDYuMTk4LjExMQAFAQAAAAAAAAAAAAAAABAEAAAAAAAAAAAAP/7STwAAlrpHdt/hvRAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACMAcD4zgQEAAAADAAAA; BP=FR=&ST=&l=SDX.Skydrive' -H 'TE: trailers' --output Install_NDI_SDK_v5_Linux.sh
RUN     chmod +x Install_NDI_SDK_v5_Linux.sh
RUN     y | ./Install_NDI_SDK_v5_Linux.sh

# ToDo..... mv rename file to underscore: (find fix for this workaround)
RUN     mv NDI\ SDK\ for\ Linux NDI_SDK_for_Linux

# Put NDI lib ref text into conf file
RUN     echo "/ndi/NDI_SDK_for_Linux/lib/x86_64-linux-gnu" >> /etc/ld.so.conf.d/ndi.conf
RUN     ldconfig


FROM	ndi as ffmpeg

# Environment
ENV	PKG_CONFIG_PATH=/ffmpeg_build/ffmpeg/lib/pkgconfig

# Build dependencies:
RUN	buildDeps="autoconf \
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

# Fetch FFmpeg:
WORKDIR	"/ffmpeg_sources"
RUN	wget -O ffmpeg-4.1.1.tar.bz2 http://ffmpeg.org/releases/ffmpeg-4.1.1.tar.bz2 && \
	tar xjvf ffmpeg-4.1.1.tar.bz2
RUN	mv ffmpeg-4.1.1 ffmpeg

# Compile FFmpeg:
WORKDIR	"/ffmpeg_sources/ffmpeg"
RUN	./configure \
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

RUN	make
RUN	make install


#KAOL Remove restriction in Avahi - put a # in front of rlimit-nproc=3
#RUN sed -i '/rlimit-nproc/s/^/#/' /etc/avahi/avahi-daemon.conf

#Start Dbus & Avahi to handle mDNS
RUN	update-rc.d dbus defaults
RUN	update-rc.d avahi-daemon defaults

# Cleanup 
RUN	mv /ffmpeg_sources/ffmpeg/ffmpeg /usr/local/ffmpeg
RUN	rm /ndi/InstallNDISDK_v3_Linux.sh


#For network testing ------ KAOL uncomment to test
RUN	apt-get install -yq --no-install-recommends net-tools iputils-ping

#ADD Avahi script for running Daemon on startup
ADD	"start.sh" "/root/start.sh"
RUN	chmod +x /root/start.sh

#Make User - to be able to run Avahi:
#RUN useradd -r -u 1901 dockeruser
#USER dockeruser

ENTRYPOINT	["/root/start.sh"]
ENV		LD_LIBRARY_PATH=/usr/local/lib

EXPOSE	5000-6000/udp
EXPOSE	5000-6000
