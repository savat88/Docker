FROM nginx:alpine

# คัดลอกไฟล์ nginx.conf ไปยังเซิร์ฟเวอร์
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html

# เปิดพอร์ต 8080
EXPOSE 8080

# รัน Nginx
CMD ["nginx", "-g", "daemon off;"]
