# ใช้ OpenResty เป็น Base Image
FROM openresty/openresty:alpine

# ติดตั้ง SQLite และ wget ด้วย apk
RUN apk update && apk add --no-cache sqlite sqlite-dev wget

# ตรวจสอบว่า LuaJIT และ lsqlite3 ติดตั้งแล้ว
RUN opm install ledgetech/lua-resty-http
RUN opm install lua-sql/sqlite3

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
