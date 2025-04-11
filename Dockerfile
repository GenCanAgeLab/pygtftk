# Use a suitable base image
FROM python:3.9-slim

# Install git, build tools, and required C/C++ libraries using Debian equivalents
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

# Clone your fork (assuming it has the corrected setup.py from before, though it might not matter now)
RUN git clone https://github.com/GenCanAgeLab/pygtftk.git /opt/pygtftk

WORKDIR /opt/pygtftk

# Install ALL Python dependencies from requirements.txt first
# This ensures numpy, cython, and everything else is present before building pygtftk
RUN pip install --no-cache-dir -r requirements.txt

# Now, build the wheel for pygtftk (without its already installed dependencies)
# The wheel format might handle the complex build steps better
RUN pip wheel . --no-deps -w /tmp/wheelhouse

# Install pygtftk from the built wheel
# Using --no-deps because we already installed them via requirements.txt
RUN pip install --no-cache-dir --no-deps /tmp/wheelhouse/pygtftk*.whl

# Optional: Clean up the temporary wheelhouse
RUN rm -rf /tmp/wheelhouse

# Set final working directory for running the tool inside the container
WORKDIR /data

# Note: The 'gtftk' executable should be installed in PATH (/usr/local/bin) by pip install.