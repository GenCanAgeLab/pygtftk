# Use a suitable base image
FROM python:3.9-slim

# Install git, build tools (like gcc, make), AND the zlib development library
RUN apt-get update && \
    apt-get install -y --no-install-recommends git build-essential zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# Clone your fork (which now includes the setup.py fix)
RUN git clone https://github.com/GenCanAgeLab/pygtftk.git /opt/pygtftk

# Install build-time dependencies (numpy, cython) needed by setup.py *before* installing the package
RUN pip install --no-cache-dir numpy cython

# Install the package and its remaining *runtime* dependencies from the cloned directory
WORKDIR /opt/pygtftk
# The '.' tells pip to install from the current directory (setup.py)
RUN pip install --no-cache-dir .

# Set final working directory for running the tool inside the container
WORKDIR /data