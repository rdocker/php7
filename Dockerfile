FROM centos:6.7
MAINTAINER ronnie <comdeng@live.com>

ENV TZ "Asia/Shanghai"

RUN \
    cd /opt/ &&\
    curl http://mirrors.aliyun.com/repo/Centos-6.repo -o /etc/yum.repos.d/CentOS-Base.repo &&\
    curl http://cn2.php.net/get/php-7.0.5.tar.gz/from/this/mirror -L -o php-7.0.5.tar.gz &&\
    yum -y install tar &&\
    tar xvfz php-7.0.5.tar.gz &&\
    yum -y install gcc libxml2-devel openssl-devel curl-devel libjpeg-devel libpng-devel freetype-devel libtidy-devel &&\
    cd php-7.0.5 &&\
    ./configure  --prefix=/opt/php --disable-cgi --without-sqlite3 --without-pdo-sqlite --enable-mysqlnd --enable-fpm --enable-mbstring --enable-zip --with-zlib --with-curl --with-libdir=lib64 --with-mysqli --with-tidy --with-openssl --enable-pcntl --with-gd --enable-gd-native-ttf --with-jpeg-dir --with-png-dir --with-freetype-dir --with-pdo-mysql &&\
    make install &&\
    cd ../ &&\
    rm  php-7.0.5* -rf &&\
    echo "install mongodb" &&\
    curl http://pecl.php.net/get/mongodb-1.1.6.tgz -o mongodb-1.1.6.tgz &&\
    tar xvfz mongodb-1.1.6.tgz &&\
    cd mongodb-1.1.6 &&\
    /opt/php/bin/phpize &&\
    ./configure --with-php-config=/opt/php/bin/php-config &&\
    make install &&\
    cd ../ &&\
    rm mongodb* -rf &&\
    echo "install imagick" &&\
    yum -y install ImageMagick-devel &&\
    curl http://pecl.php.net/get/imagick-3.4.1.tgz -o imagick-3.4.1.tgz &&\
    tar xvfz imagick-3.4.1.tgz &&\
    cd imagick-3.4.1 &&\
    /opt/php/bin/phpize &&\
    ./configure --with-php-config=/opt/php/bin/php-config &&\
    make install &&\
    cd .. &&\
    rm  imagick* -rf &&\
    echo "install redis" &&\
    curl https://github.com/phpredis/phpredis/archive/php7.zip -L -o phpredis.zip &&\
    yum -y install unzip &&\
    unzip phpredis.zip &&\
    cd phpredis-php7 &&\
    /opt/php/bin/phpize &&\
    ./configure --with-php-config=/opt/php/bin/php-config &&\
    make install &&\
    cd ../ &&\
    rm phpredis* -rf &&\
    yum -y erase tar unzip ImagickMagick-devel libxml2-devel openssl-devel curl-devel libjpeg-devel libpng-devel freetype-devel libtidy-devel &&\
    yum clean all


ADD ./php.ini /opt/php/lib/php.ini
ADD ./php-fpm.conf /opt/php/etc/php-fpm.d/php7.conf
RUN mv /opt/php/etc/php-fpm.conf.default /opt/php/etc/php-fpm.conf && useradd work && chown work:work /opt/php/var/ -R

EXPOSE 9200

ENTRYPOINT ["/opt/php/sbin/php-fpm","--nodaemonize"]
