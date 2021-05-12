ARG RESTY_IMAGE_BASE="ubuntu"
ARG RESTY_IMAGE_TAG="bionic"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

ARG RESTY_VERSION="1.19.3.1"
ARG RESTY_LUAROCKS_VERSION="3.3.1"
ARG MAGICK_VERSION="1.3.35"

RUN apt-get update \
&& apt-get -y install \
    git \
    gcc \
    g++\
    make \
    automake \
    autoconf \
    libtool \
    pcre2-utils \
    libpcre2-dev \
    zlib1g \
    zlib1g-dev \
    openssl \
    libssh-dev \
    wget \
    vim \
    unzip \
    libmagickwand-dev \
    libssl-dev \
    lzip \
    graphicsmagick

COPY ./libfastcommon /usr/local/src/libfastcommon
COPY ./fastdfs /usr/local/src/fastdfs
COPY ./fastdfs-nginx-module /usr/local/src/fastdfs-nginx-module
COPY ./fastdfs.sh /home

RUN cd /usr/local/src \
&& cd libfastcommon/ \
&& ./make.sh \
&& ./make.sh install \
&& cd ../ \
&& cd fastdfs/ \
&& ./make.sh \
&& ./make.sh install \
&& cp /usr/local/src/fastdfs/conf/http.conf /etc/fdfs/ \
&& cp /usr/local/src/fastdfs/conf/mime.types /etc/fdfs/ \
&& cp /usr/local/src/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs

RUN cd /tmp \
&& wget https://openresty.org/download/openresty-${RESTY_VERSION}.tar.gz \
&& tar -zxvf openresty-${RESTY_VERSION}.tar.gz \
&& cd openresty-*/ \
&& ./configure \
    --with-luajit \
    --with-http_iconv_module \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-stream \
    --with-stream_ssl_module \
    --add-module=/usr/local/src/fastdfs-nginx-module/src/ \
&& make -j4 \
&& make install

RUN cd /tmp \
&& wget http://luarocks.github.io/luarocks/releases/luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz \
&& tar -xzvf luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz \
&& cd luarocks-${RESTY_LUAROCKS_VERSION} \
&& ./configure --with-lua=/usr/local/openresty/luajit/ \
&& make \
&& make install

RUN luarocks install magick

RUN cd /tmp \
&& wget https://nchc.dl.sourceforge.net/project/graphicsmagick/graphicsmagick/${MAGICK_VERSION}/GraphicsMagick-${MAGICK_VERSION}.tar.lz \
&& lzip -d GraphicsMagick-${MAGICK_VERSION}.tar.lz \
&& tar -xvf GraphicsMagick-${MAGICK_VERSION}.tar \
&& cd GraphicsMagick-${MAGICK_VERSION}/ \
&& ./configure '--with-magick=wand/GraphicsMagickWand-config' '--enable-shared' \
&& make \
&& make install \
&& chmod +x /home/fastdfs.sh

ARG MKDIR_DATA_PATH="/www/dfs"
ENV ENV_DATA_PATH=$MKDIR_DATA_PATH

ADD config /usr/local/openresty/nginx/conf
ADD vhost /usr/local/openresty/nginx/conf/vhost
ADD fastdfs_config /etc/fdfs

RUN ln -s /usr/local/src/fastdfs/init.d/fdfs_trackerd /etc/init.d/fdfs_trackerd \
  && ln -s /usr/local/src/fastdfs/init.d/fdfs_storaged /etc/init.d/fdfs_storaged

EXPOSE 22122 23000 8888 8080 80 443

ENTRYPOINT ./home/fastdfs.sh $ENV_DATA_PATH

STOPSIGNAL SIGQUIT
