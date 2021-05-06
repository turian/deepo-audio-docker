FROM ufoym/deepo
#FROM nvidia/cuda:11.1-cudnn8-devel-ubuntu18.04

# buildpack-deps:stretch
RUN set -ex; \
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive \
	apt-get install -y --no-install-recommends \
		autoconf \
		automake \
		bzip2 \
		dpkg-dev \
		file \
		g++ \
		gcc \
		imagemagick \
		libbz2-dev \
		libc6-dev \
		libcurl4-openssl-dev \
		libdb-dev \
		libevent-dev \
		libffi-dev \
		libgdbm-dev \
		libglib2.0-dev \
		libgmp-dev \
		libjpeg-dev \
		libkrb5-dev \
		liblzma-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libmaxminddb-dev \
		libncurses5-dev \
		libncursesw5-dev \
		libpng-dev \
		libpq-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		libtool \
		libwebp-dev \
		libxml2-dev \
		libxslt-dev \
		libyaml-dev \
		make \
		patch \
		unzip \
		xz-utils \
		zlib1g-dev \
		wget \
		nano \
		$( \
			if apt-cache show 'default-libmysqlclient-dev' 2>/dev/null | grep -q '^Version:'; then \
				echo 'default-libmysqlclient-dev'; \
			else \
				echo 'libmysqlclient-dev'; \
			fi \
		) \
	; \
	rm -rf /var/lib/apt/lists/*

# python:3.7.7-stretch
ENV PATH /usr/local/bin:$PATH

ENV LANG C.UTF-8
# workaround readline fallback
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && apt-get install -y -q

#RUN apt-get update && apt-get install -y --no-install-recommends \
#		libbluetooth-dev \
#		tk-dev \
#		uuid-dev \
#	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get dist-upgrade -y

RUN apt-get install -y \
	ffmpeg \
	libopenmpi-dev \
	openmpi-bin \
	libsndfile1 \
	libavdevice-dev \
	libavfilter-dev \
	ssh

# some useful commandline tools
RUN apt-get install -y vim less bc man man-db manpages psmisc screen zip unzip sox git awscli util-linux atop htop normalize-audio

# install a pyaudio dependency
RUN apt-get update \
    && apt-get install -y portaudio19-dev

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# spotty requirements
RUN pip install --upgrade PyYAML schema chevron botocore boto3 pycurl

RUN pip install --upgrade gputil psutil humanize av ipython sox jupyter jupytext pydub python-slugify luigi tqdm tensorboard tensorboardX

RUN pip install --upgrade black flake8 flake8-black

# Audio + deep-learning libraries
RUN pip install --upgrade librosa torchlibrosa tensor-sensor efficientnet_pytorch seaborn pytorch_memlab[ipython]
RUN pip install --upgrade mpi4py torch torchvision av

RUN pip install --upgrade soundfile wandb samplerate resampy auraloss nnAudio pytorch-lightning

# Speech eval
# Not working right now :\
#RUN pip install --upgrade pystoi pesq speechmetrics

RUN pip install --upgrade linear_attention_transformer

# For some image GANs
RUN pip install --upgrade torchvision dominate visdom packaging GPUtil

# TODO: APEX?

# I'm not sure we actually want this
RUN apt-get install -y python3-tk 

RUN apt-get install -y mlocate \
    && updatedb

# Clean deps
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#EXPOSE 6006
