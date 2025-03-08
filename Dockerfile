# ใช้ OpenResty Alpine เป็น Base Image (Nginx + Lua)
FROM openresty/openresty:alpine

# ติดตั้ง SQLite และ wget ด้วย apk
RUN apk update && apk add --no-cache \
    sqlite \
    sqlite-dev \
    wget

# คัดลอกไฟล์ config ของ Nginx (OpenResty)
COPY nginx.conf /etc/nginx/nginx.conf

# คัดลอกไฟล์ init script
COPY init.sh /init.sh
RUN chmod +x /init.sh

# สร้างโฟลเดอร์สำหรับ HLS และฐานข้อมูล
RUN mkdir -p /var/www/html/hls
RUN sqlite3 /var/www/html/urls.db "CREATE TABLE IF NOT EXISTS urls (original TEXT PRIMARY KEY, converted TEXT);"

# เปิดพอร์ต 80
EXPOSE 80

# รัน init script แล้วเริ่มต้น OpenResty (Nginx)
CMD ["/bin/bash", "-c", "/init.sh && /usr/local/openresty/bin/openresty -g 'daemon off;'"]
