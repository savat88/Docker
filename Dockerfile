# ใช้ Nginx Base Image
FROM nginx:alpine

# ติดตั้ง dependencies ที่จำเป็น รวมถึง git
RUN apk add --no-cache \
    build-base \
    libtool \
    autoconf \
    gcc \
    make \
    pcre-dev \
    zlib-dev \
    git \
    && rm -rf /var/cache/apk/*

# ดาวน์โหลดและติดตั้ง RTMP module
RUN git clone https://github.com/arut/nginx-rtmp-module /nginx-rtmp-module

# คัดลอกไฟล์ nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# เปิดพอร์ตที่จำเป็น
EXPOSE 1935

# เริ่ม Nginx
CMD ["nginx", "-g", "daemon off;"]
