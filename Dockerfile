FROM centos:centos7

MAINTAINER kakuilan kakuilan@163.com

ARG TZ=Asia/Shanghai
ARG SRC_DIR=/usr/local/src
ARG WWW_USER=www
ARG WWW_DIR=/var/www

# nginx相关包
ARG NGBUILD_VER=0.11.18
ARG ZLIB_VER=1.2.11
ARG PCRE_VER=8.45
ARG OPENSSL_VER=1.1.1m
ARG OPENRESTY_VER=1.24.1.1rc1
ARG LUAROCKS_VERSION=3.8.0
ARG IMAGEMAGICK_VERSION=7.1.0-19
ARG IMAGEMAGICK6_VERSION=6.9.12-34

# php相关包
ARG RE2C_VER=2.2
ARG LIBICONV_VER=1.16
ARG LIBZIP_VER=1.8.0
ARG PHP_VER=7.4.27
ARG PHP_8VER=8.0.14
ARG PHP_AMQP_VER=1.11.0
ARG PHP_GRPC_VER=1.43.0RC1
ARG PHP_IMAGICK_VER=3.6.0
ARG PHP_INOTIFY_VER=3.0.0
ARG PHP_MCRYPT_VER=1.0.4
ARG PHP_MEMCACHED_VER=3.1.5
ARG PHP_MONGODB_VER=1.12.0
ARG PHP_MSGPACK_VER=2.1.2
ARG PHP_NSQ_VER=3.5.1
ARG PHP_PROTOBUF_VER=3.19.1
ARG PHP_REDIS_VER=5.3.5
ARG PHP_PHALCON_VER=4.1.2
ARG PHP_SWOOLE_VER=4.8.5
ARG PHP_XDEBUG_VER=3.1.2
ARG PHP_XHPROF_VER=2.3.5

# golang
ARG GO111MODULE=on
ARG GOPROXY=https://goproxy.cn

# copy files
COPY conf ${SRC_DIR}
COPY files ${SRC_DIR}

# copy conf
RUN \cp -f /usr/local/src/mercurial.repo /etc/yum.repos.d/ \

# update yum repo
    && yum install -y curl yum-utils deltarpm epel-release centos-release-scl \
    && rpm --import https://mirror.go-repo.io/centos/RPM-GPG-KEY-GO-REPO \
    && yum-config-manager --add-repo https://mirror.go-repo.io/centos/go-repo.repo \
    && set -o pipefail && curl -sL https://rpm.nodesource.com/setup_14.x | bash - \
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
    psmisc \
    subversion \
    telnet \
    tcpdump \
    tree \
    tzdata \
    unzip \
    unar \
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
    openssl \
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

# install packaging tools & upgrade gcc
    && yum install -y golang nodejs yarn devtoolset-8-gcc* \
# set git conf
    && git config --global http.postBuffer 1048576000 \
    && git config --global http.lowSpeedLimit 0 \
    && git config --global http.lowSpeedTime 999999 \
# make www dir add user
    #&& echo "185.199.108.133 raw.githubusercontent.com" >> /etc/hosts \
    && mkdir -p ${WWW_DIR} \
    && useradd -M -s /sbin/nologin ${WWW_USER} \
    && cd ${SRC_DIR} \

# download nginx soft source pack
    #&& wget https://github.com/cubicdaiya/nginx-build/releases/download/v${NGBUILD_VER}/nginx-build-linux-amd64-${NGBUILD_VER}.tar.gz -O nginx-build-linux-amd64-${NGBUILD_VER}.tar.gz \
    && go install github.com/cubicdaiya/nginx-build@latest \
    #&& wget https://zlib.net/fossils/zlib-${ZLIB_VER}.tar.gz -O zlib-${ZLIB_VER}.tar.gz \
    #&& wget https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VER}.tar.gz -O pcre-${PCRE_VER}.tar.gz \
    && wget https://www.openssl.org/source/openssl-${OPENSSL_VER}.tar.gz -O openssl-${OPENSSL_VER}.tar.gz --no-check-certificate \
    && wget https://openresty.org/download/openresty-${OPENRESTY_VER}.tar.gz -O openresty-${OPENRESTY_VER}.tar.gz --no-check-certificate \
    # https://github.com/luarocks/luarocks/releases
    && curl -fSL https://codeload.github.com/luarocks/luarocks/tar.gz/v${LUAROCKS_VERSION} -o luarocks-${LUAROCKS_VERSION}.tar.gz \
    && curl -fSL https://codeload.github.com/ImageMagick/ImageMagick/tar.gz/${IMAGEMAGICK_VERSION} -o ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz \
    && curl -fSL https://codeload.github.com/ImageMagick/ImageMagick6/tar.gz/${IMAGEMAGICK6_VERSION} -o ImageMagick-${IMAGEMAGICK6_VERSION}.tar.gz \

# download php soft source pack
    && wget https://github.com/skvadrik/re2c/releases/download/${RE2C_VER}/re2c-${RE2C_VER}.tar.xz -O re2c-${RE2C_VER}.tar.xz \
    # http://www.gnu.org/software/libiconv/#downloading
    && wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-${LIBICONV_VER}.tar.gz \
    && wget https://libzip.org/download/libzip-${LIBZIP_VER}.tar.gz \
    && wget http://hk1.php.net/get/php-${PHP_VER}.tar.gz/from/this/mirror -O php-${PHP_VER}.tar.gz \
    && wget http://hk1.php.net/get/php-${PHP_8VER}.tar.gz/from/this/mirror -O php-${PHP_8VER}.tar.gz \
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
    && wget https://pecl.php.net/get/phalcon-${PHP_PHALCON_VER}.tgz \
    && wget https://pecl.php.net/get/swoole-${PHP_SWOOLE_VER}.tgz \
    && wget http://pecl.php.net/get/xdebug-${PHP_XDEBUG_VER}.tgz \
    && wget https://github.com/longxinH/xhprof/archive/v${PHP_XHPROF_VER}.tar.gz -O xhprof.${PHP_XHPROF_VER}.tar.gz \
    && wget https://getcomposer.org/installer -O composer-installer.php \
    && wget -O phpunit https://phar.phpunit.de/phpunit-9.phar \

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
