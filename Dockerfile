# ใช้ Ubuntu เป็น Base Image
FROM ubuntu:latest

# ติดตั้ง Nginx, Lua, SQLite, และ wget
RUN apt update && apt install -y \
    nginx \
    lua5.3 \
    liblua5.3-dev \
    sqlite3 \
    libsqlite3-dev \
    wget

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

# รัน init script
CMD ["/init.sh"]
