FROM centos:centos7

MAINTAINER kakuilan kakuilan@163.com

ENV TZ=Asia/Shanghai \
    SRC_DIR=/usr/local/src

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
    tree \
    tzdata \
    unzip \
    wget \
    which \

# install development libs dependency
    GeoIP \
    GeoIP-devel \
    ImageMagick-devel \
    bison-devel \
    bzip2-devel \
    cronie \
    crontabs \
    cyrus-sasl-devel \
    expat-devel \
    freetype-devel \
    gd-devel \
    gdbm-devel \
    geoipupdate \
    geoipupdate-cron \
    gettext-devel \
    glib2-devel \
    glibc-devel \
    gmp-devel \
    imlib2-devel \
    libX11-devel \
    libXext-devel \
    libXpm-devel \
    libargon2 \
    libargon2-devel \
    libc-client-devel \
    libcurl-devel \
    libgomp \
    libicu-devel \
    libidn-devel \
    libjpeg-devel \
    libjpeg-turbo \
    libjpeg-turbo-devel \
    libmcrypt-devel \
    libpng-devel \
    libpqxx-devel \
    libsodium-devel \
    libtidy-devel \
    libtool-ltdl-devel \
    libuuid-devel \
    libwebp-devel \
    libxml2-devel \
    libxslt-devel \
    libzip-devel \
    logrotate \
    mariadb-devel \
    mhash-devel \
    net-snmp-devel \
    oniguruma-devel \
    openssl-devel \
    pcre-devel \
    postgresql-devel \
    readline-devel \
    sqlite-devel \
    unixODBC-devel \
    uw-imap-devel \
    xmlrpc-c-devel \
    zlib-devel \

# install packaging tools
    && yum install -y golang nodejs yarn \

    && rm -rf ${SRC_DIR}/* \
    && rm -rf /run/log/* \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/yum/* \
    && rm -rf /var/log/* \
    && rm -rf /var/tmp/* \
    && rm -rf /usr/local/share/man/* \
    && rm -rf /usr/local/share/doc/* \
    && rm -rf /usr/share/doc/* \
    && rm -rf /usr/share/man/* \
    && mkdir -p ${LOG_DIR} \
    && history -c && history -w
