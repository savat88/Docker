FROM ubuntu:20.04

# อัปเดตและติดตั้ง dependencies ที่จำเป็น
RUN apt-get update && apt-get install -y \
    build-essential \
    libtool \
    autoconf \
    gcc \
    make \
    pcre3-dev \
    zlib1g-dev \
    git \
    wget \
    curl \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# ดาวน์โหลด OpenSSL, Nginx และ RTMP module
RUN wget https://www.openssl.org/source/openssl-1.1.1k.tar.gz && \
    tar -zxvf openssl-1.1.1k.tar.gz

RUN wget http://nginx.org/download/nginx-1.23.1.tar.gz && \
    tar -zxvf nginx-1.23.1.tar.gz

RUN git clone https://github.com/arut/nginx-rtmp-module /nginx-rtmp-module

# คอมไพล์ Nginx พร้อม RTMP module และ OpenSSL
WORKDIR nginx-1.23.1
RUN ./configure --with-compat --with-openssl=/openssl-1.1.1k --add-dynamic-module=/nginx-rtmp-module && \
    make && \
    make install

# กำหนดพอร์ตและคำสั่งเริ่ม Nginx
EXPOSE 1935 8080
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
