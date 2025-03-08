# Use the official Nginx image from Docker Hub
FROM nginx:alpine

# Install dependencies for RTMP module
RUN apk add --no-cache \
    build-base \
    libtool \
    autoconf \
    gcc \
    make \
    pcre-dev \
    zlib-dev \
    && rm -rf /var/cache/apk/*

# Download and install the Nginx RTMP module
RUN git clone https://github.com/arut/nginx-rtmp-module /nginx-rtmp-module

# Copy Nginx configuration file (nginx.conf) into the container
COPY nginx.conf /etc/nginx/nginx.conf

# Expose the necessary ports
EXPOSE 1935

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
