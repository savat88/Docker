# ใช้ Alpine image สำหรับติดตั้ง dependencies
FROM alpine:latest

# ติดตั้ง dependencies ที่จำเป็น
RUN apk add --no-cache \
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
    && rm -rf /var/cache/apk/*

# ดาวน์โหลดและคอมไพล์ Nginx พร้อม RTMP module
RUN wget http://nginx.org/download/nginx-1.23.1.tar.gz && \
    tar -zxvf nginx-1.23.1.tar.gz && \
    git clone https://github.com/arut/nginx-rtmp-module /nginx-rtmp-module && \
    cd nginx-1.23.1 && \
    ./configure --with-compat --add-dynamic-module=/nginx-rtmp-module && \
    make && \
    make install

# คัดลอกไฟล์ nginx.conf ที่กำหนด
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# เปิดพอร์ตที่จำเป็น
EXPOSE 1935 8080

# เริ่ม Nginx
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
