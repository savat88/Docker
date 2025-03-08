#!/bin/sh

# สร้างโฟลเดอร์สำหรับ HLS ถ้ายังไม่มี
mkdir -p /var/www/html/hls

# สร้างฐานข้อมูล SQLite ถ้ายังไม่มี
if [ ! -f "/var/www/html/urls.db" ]; then
    sqlite3 /var/www/html/urls.db "CREATE TABLE IF NOT EXISTS urls (original TEXT PRIMARY KEY, converted TEXT);"
fi

# รัน OpenResty
/usr/local/openresty/bin/openresty -g "daemon off;"
