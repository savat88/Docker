# ใช้ OpenResty (Debian Base)
FROM openresty/openresty:latest

# ติดตั้ง Git, SQLite, wget, curl, unzip และ Luarocks
RUN apt update && apt install -y \
    git \
    sqlite3 \
    libsqlite3-dev \
    wget \
    curl \
    unzip \
    luarocks

# **ติดตั้ง Lua Modules ที่จำเป็น**
RUN luarocks install lua-resty-http
RUN luarocks install luasql-sqlite3

# คัดลอกไฟล์ config ของ Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# คัดลอกไฟล์ init script
COPY init.sh /init.sh
RUN chmod +x /init.sh

# สร้างโฟลเดอร์สำหรับ HLS และฐานข้อมูล
RUN mkdir -p /var/www/html/hls
RUN sqlite3 /var/www/html/urls.db "CREATE TABLE IF NOT EXISTS urls (original TEXT PRIMARY KEY, converted TEXT);"

# เปิดพอร์ต 80
EXPOSE 80

# รัน OpenResty
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
