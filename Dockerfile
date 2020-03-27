FROM centos:centos7

MAINTAINER kakuilan kakuilan@163.com

ARG TZ=Asia/Shanghai
ARG SRC_DIR=/usr/local/src
ARG WWW_USER=www
ARG WWW_DIR=/var/www

# nginx相关包
ARG NGBUILD_VER=0.11.8
ARG ZLIB_VER=1.2.11
ARG PCRE_VER=8.44
ARG OPENSSL_VER=1.1.1e
ARG OPENRESTY_VER=1.15.8.3
ARG LUAROCKS_VERSION=3.3.1
ARG IMAGEMAGICK_VERSION=7.0.10-2

# php相关包
ARG RE2C_VER=1.3
ARG LIBICONV_VER=1.16
ARG LIBZIP_VER=1.6.1
ARG PHP_VER=7.4.4
ARG PHP_AMQP_VER=1.9.4
ARG PHP_GRPC_VER=1.27.0
ARG PHP_IMAGICK_VER=3.4.4
ARG PHP_INOTIFY_VER=2.0.0
ARG PHP_MCRYPT_VER=1.0.3
ARG PHP_MEMCACHED_VER=3.1.5
ARG PHP_MONGODB_VER=1.7.4
ARG PHP_MSGPACK_VER=2.1.0
ARG PHP_NSQ_VER=3.5.0
ARG PHP_PROTOBUF_VER=3.11.4
ARG PHP_REDIS_VER=5.2.1
ARG PHP_SWOOLE_VER=4.4.16
ARG PHP_XDEBUG_VER=2.9.3
ARG PHP_XHPROF_VER=2.1.3

# copy files
COPY conf ${SRC_DIR}

# copy conf
RUN \cp -f /usr/local/src/mercurial.repo /etc/yum.repos.d/ \

# update yum repo
    && yum install -y curl yum-utils deltarpm epel-release \
    && rpm --import https://mirror.go-repo.io/centos/RPM-GPG-KEY-GO-REPO \
    && yum-config-manager --add-repo https://mirror.go-repo.io/centos/go-repo.repo \
    && set -o pipefail && curl -sL https://rpm.nodesource.com/setup_12.x | bash - \
    && set -o pipefail && curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo \
    && yum repolist \

# install compile dependency
    && yum -y groupinstall "Development tools" \
    && yum install -y \
    autoconf \
    automake \
    bzip2 \
    cmake \
    cmake3 \
    curl \
    dos2unix \
    gcc \
    gcc-c++ \
    git \
    m4 \
    make \
    mercurial \
    net-tools \
    patch \
    subversion \
    telnet \
    tcpdump \
    tree \
    tzdata \
    unzip \
    wget \
    which \

# install development libs dependency
    GeoIP-devel \
    ImageMagick-devel \
    OpenEXR-devel \
    bison-devel \
    bzip2-devel \
    cyrus-sasl-devel \
    expat-devel \
    file-devel \
    freetype-devel \
    gd-devel \
    gdbm-devel \
    gettext-devel \
    ghostscript-devel \
    giflib-devel \
    glib2-devel \
    glibc-devel \
    gmp-devel \
    imlib2-devel \
    jasper-devel \
    lcms2-devel \
    libX11-devel \
    libXext-devel \
    libXpm-devel \
    libXt-devel \
    libargon2 \
    libargon2-devel \
    libc-client-devel \
    libcurl-devel \
    libevent-devel \
    libgomp \
    libicu-devel \
    libidn-devel \
    libjpeg-devel \
    libjpeg-turbo \
    libjpeg-turbo-devel \
    libmcrypt-devel \
    libmemcached-devel \
    libpng-devel \
    libpqxx-devel \
    librabbitmq-devel \
    librsvg2-devel \
    libsodium-devel \
    libtidy-devel \
    libtiff-devel \
    libtool-ltdl-devel \
    libuuid-devel \
    libwebp-devel \
    libwmf-devel \
    libxml2-devel \
    libxslt-devel \
    libzip-devel \
    mariadb-devel \
    mhash-devel \
    net-snmp-devel \
    oniguruma-devel \
    openssl-devel \
    pcre-devel \
    perl-devel \
    postgresql-devel \
    readline-devel \
    rpm-build \
    sqlite-devel \
    unixODBC-devel \
    uw-imap-devel \
    xmlrpc-c-devel \
    zlib-devel \

# install packaging tools
    && yum install -y golang nodejs yarn \

# make www dir add user
    && mkdir -p ${WWW_DIR} \
    && useradd -M -s /sbin/nologin ${WWW_USER} \
    && cd ${SRC_DIR} \

# download nginx soft source pack
    && wget https://github.com/cubicdaiya/nginx-build/releases/download/v${NGBUILD_VER}/nginx-build-linux-amd64-${NGBUILD_VER}.tar.gz -O nginx-build-linux-amd64-${NGBUILD_VER}.tar.gz \
    && wget https://zlib.net/fossils/zlib-${ZLIB_VER}.tar.gz -O zlib-${ZLIB_VER}.tar.gz \
    && wget https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VER}.tar.gz -O pcre-${PCRE_VER}.tar.gz \
    && wget https://www.openssl.org/source/openssl-${OPENSSL_VER}.tar.gz -O openssl-${OPENSSL_VER}.tar.gz \
    && wget https://openresty.org/download/openresty-${OPENRESTY_VER}.tar.gz -O openresty-${OPENRESTY_VER}.tar.gz \
    && curl -fSL https://luarocks.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz -o luarocks-${LUAROCKS_VERSION}.tar.gz \
    && curl -fSL https://codeload.github.com/ImageMagick/ImageMagick/tar.gz/${IMAGEMAGICK_VERSION} -o ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz \

# download php soft source pack
    && wget https://github.com/skvadrik/re2c/releases/download/${RE2C_VER}/re2c-${RE2C_VER}.tar.xz -O re2c-${RE2C_VER}.tar.xz \
    && wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-${LIBICONV_VER}.tar.gz \
    && wget https://libzip.org/download/libzip-${LIBZIP_VER}.tar.gz \
    && wget http://hk1.php.net/get/php-${PHP_VER}.tar.gz/from/this/mirror -O php-${PHP_VER}.tar.gz \
    && wget http://pecl.php.net/get/amqp-${PHP_AMQP_VER}.tgz \
    && wget http://pecl.php.net/get/grpc-${PHP_GRPC_VER}.tgz \
    && wget https://pecl.php.net/get/imagick-${PHP_IMAGICK_VER}.tgz \
    && wget https://pecl.php.net/get/inotify-${PHP_INOTIFY_VER}.tgz \
    && wget https://pecl.php.net/get/mcrypt-${PHP_MCRYPT_VER}.tgz \
    && wget https://pecl.php.net/get/memcached-${PHP_MEMCACHED_VER}.tgz \
    && wget https://pecl.php.net/get/mongodb-${PHP_MONGODB_VER}.tgz \
    && wget http://pecl.php.net/get/msgpack-${PHP_MSGPACK_VER}.tgz \
    && wget https://pecl.php.net/get/nsq-${PHP_NSQ_VER}.tgz \
    && wget http://pecl.php.net/get/protobuf-${PHP_PROTOBUF_VER}.tgz \
    && wget https://pecl.php.net/get/redis-${PHP_REDIS_VER}.tgz \
    && wget https://pecl.php.net/get/swoole-${PHP_SWOOLE_VER}.tgz \
    && wget http://pecl.php.net/get/xdebug-${PHP_XDEBUG_VER}.tgz \
    && wget https://github.com/longxinH/xhprof/archive/v${PHP_XHPROF_VER}.tar.gz -O xhprof.${PHP_XHPROF_VER}.tar.gz \

# clear cache
    && yum clean all \
    && rm -rf /run/log/* \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/yum/* \
    && rm -rf /var/log/* \
    && rm -rf /var/tmp/* \
    && rm -rf /usr/local/share/man/* \
    && rm -rf /usr/local/share/doc/* \
    && rm -rf /usr/share/doc/* \
    && rm -rf /usr/share/man/* \
    && history -c && history -w
