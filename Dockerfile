# ใช้ Nginx พร้อม Alpine Linux เพื่อลดขนาด
FROM nginx:alpine

# ติดตั้ง dependencies ที่จำเป็น
RUN apk update && apk add --no-cache \
    git \
    build-base \
    pcre-dev \
    zlib-dev \
    openssl-dev

# ดาวน์โหลด RTMP module และ Nginx
RUN wget http://nginx.org/download/nginx-1.21.6.tar.gz && \
    tar -zxvf nginx-1.21.6.tar.gz && \
    git clone https://github.com/arut/nginx-rtmp-module.git

WORKDIR /nginx-1.21.6

RUN ./configure --add-module=../nginx-rtmp-module && \
    make && \
    make install

# คัดลอกไฟล์ตั้งค่า Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# เปิดพอร์ต 1935 (RTMP) และ 8080 (HTTP)
EXPOSE 1935 8080

# คำสั่งรัน Nginx
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
