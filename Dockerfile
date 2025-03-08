# Stage 1: build
FROM ubuntu:20.04 AS builder

# ติดตั้ง dependencies
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
    libssl-dev

# ดาวน์โหลดและคอมไพล์ nginx และ rtmp module
RUN wget http://nginx.org/download/nginx-1.23.1.tar.gz && \
    tar -zxvf nginx-1.23.1.tar.gz

RUN git clone https://github.com/arut/nginx-rtmp-module /nginx-rtmp-module

WORKDIR nginx-1.23.1
RUN ./configure --with-compat --with-openssl=/openssl-1.1.1k --add-dynamic-module=/nginx-rtmp-module && \
    make && \
    make install

# Stage 2: runtime
FROM ubuntu:20.04

# คัดลอกไฟล์จาก builder
COPY --from=builder /usr/local/nginx /usr/local/nginx

# เปิดพอร์ตที่ใช้
EXPOSE 1935 8080

# คำสั่งเริ่ม nginx
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
