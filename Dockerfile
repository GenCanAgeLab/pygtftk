# Use a suitable base image
FROM python:3.9-slim

# Install git, build tools, and required C/C++ libraries
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        build-essential \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev \
        libjpeg62-turbo-dev \
        libopenblas-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone your fork (assuming it has the setup.py fix attempt, though it may not help)
RUN git clone https://github.com/GenCanAgeLab/pygtftk.git /opt/pygtftk

WORKDIR /opt/pygtftk

# Install ALL Python dependencies from requirements.txt first
# This includes numpy, cython, and all runtime dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Now, try the direct installation again, ensuring all dependencies are pre-installed
# Using --no-deps because we already installed them via requirements.txt
RUN pip install --no-cache-dir --no-deps .

# Set final working directory for running the tool inside the container
WORKDIR /data

# Note: The 'gtftk' executable should be installed in PATH (/usr/local/bin) by pip install.