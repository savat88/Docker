# ใช้ OpenResty (Debian Base)
FROM openresty/openresty:latest

# ติดตั้ง PHP-FPM, SQLite, และเครื่องมือที่จำเป็น
RUN apt update && apt install -y \
    php-fpm \
    php-sqlite3 \
    sqlite3 \
    wget \
    curl \
    unzip

# คัดลอกไฟล์ config ของ Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# คัดลอกไฟล์ PHP Script
COPY stream.php /var/www/html/stream.php

# สร้างโฟลเดอร์สำหรับ HLS และฐานข้อมูล
RUN mkdir -p /var/www/html/hls
RUN sqlite3 /var/www/html/urls.db "CREATE TABLE IF NOT EXISTS urls (original TEXT PRIMARY KEY, converted TEXT);"

# เปิดพอร์ต 80
EXPOSE 80

# รัน OpenResty และ PHP-FPM
CMD service php7.4-fpm start && /usr/local/openresty/bin/openresty -g "daemon off;"
