# ใช้ Alpine image สำหรับติดตั้ง dependencies
FROM alpine:latest

# ติดตั้ง dependencies ที่จำเป็น รวมถึง OpenSSL
RUN apk update && apk add --no-cache \
    build-base \
    libtool \
    autoconf \
    gcc \
    make \
    pcre-dev \
    zlib-dev \
    git \
    linux-headers \
    wget \
    curl \
    openssl \
    openssl-dev \
    && rm -rf /var/cache/apk/*

# ดาวน์โหลด Nginx จาก source
RUN wget http://nginx.org/download/nginx-1.23.1.tar.gz && \
    tar -zxvf nginx-1.23.1.tar.gz

# ดาวน์โหลด OpenSSL จากแหล่งทางการ
RUN wget https://www.openssl.org/source/openssl-1.1.1k.tar.gz && \
    tar -zxvf openssl-1.1.1k.tar.gz

# ดาวน์โหลด RTMP module
RUN git clone https://github.com/arut/nginx-rtmp-module /nginx-rtmp-module

# คอมไพล์ Nginx พร้อม RTMP module และ OpenSSL
WORKDIR nginx-1.23.1
RUN ./configure --with-compat --with-openssl=/openssl-1.1.1k --with-rtmp=/nginx-rtmp-module || tail -n 10 /tmp/configure.log
RUN make || tail -n 10 /tmp/make.log && \
    make install

# คัดลอกไฟล์ nginx.conf ที่กำหนด
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# เปิดพอร์ตที่จำเป็น
EXPOSE 1935 8080

# เริ่ม Nginx
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
