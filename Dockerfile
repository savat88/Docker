RUN apt-get update
RUN apt-get install -y \
    build-essential \
    libtool \
    autoconf \
    gcc \
    make \
    pcre3-dev \
    zlib1g-dev \
    git \
    wget \
    curl \
    libssl-dev
