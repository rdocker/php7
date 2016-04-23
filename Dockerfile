FROM centos:6.7
MAINTAINER ronnie <comdeng@live.com>

ENV TZ "Asia/Shanghai"

RUN curl http://mirrors.aliyun.com/repo/Centos-6.repo -o /etc/yum.repos.d/CentOS-Base.repo &&\
    curl http://cn2.php.net/get/php-7.0.5.tar.gz/from/this/mirror -L -o /root/php-7.0.5.tar.gz &&\
    yum -y install tar &&\
    cd /root/ && tar xvfz php-7.0.5.tar.gz &&\
    yum -y install gcc libxml2-devel openssl-devel curl-devel libjpeg-devel libpng-devel freetype-devel libtidy-devel &&\
    cd /root/php-7.0.5 &&\
    ./configure  --prefix=/usr/local/php --disable-cgi --without-sqlite3 --without-pdo-sqlite --enable-mysqlnd --enable-fpm --enable-mbstring --with-zlib --with-curl --with-libdir=lib64 --with-mysqli --with-tidy --with-openssl --enable-pcntl --with-gd --enable-gd-native-ttf --with-jpeg-dir --with-png-dir --with-freetype-dir --with-pdo-mysql &&\
    make install &&\
    rm  /root/php-7.0.5 -rf &&\
    yum -y erase tar libxml2-devel openssl-devel curl-devel libjpeg-devel libpng-devel freetype-devel libtidy-devel &&\
    yum clean all

ADD ./php.ini /usr/local/php/lib/php.ini
ADD ./php-fpm.conf /usr/local/php/etc/php-fpm.conf
RUN useradd work

EXPOSE 9000

ENTRYPOINT ["/usr/local/php/sbin/php-fpm","--nodaemonize"]
