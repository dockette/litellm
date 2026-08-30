ARG LITELLM_VERSION=v1.98.0

FROM ghcr.io/berriai/litellm:${LITELLM_VERSION}

LABEL maintainer="sulcmil@gmail.com"

# PIP ##########################################################################
# The upstream image ships a virtualenv at /app/.venv without pip.
RUN /app/.venv/bin/python -m ensurepip --upgrade && \
    /app/.venv/bin/python -m pip install --no-cache-dir --upgrade pip

# PILLOW #######################################################################
RUN /app/.venv/bin/python -m pip install --no-cache-dir Pillow && \
    /app/.venv/bin/python -c "from PIL import Image; print(Image.__version__)"

# HEALTHCHECK ##################################################################
# There is no curl or wget in the image, so python does the request.
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
    CMD /app/.venv/bin/python -c "import os, urllib.request; urllib.request.urlopen('http://127.0.0.1:' + os.getenv('PORT', '4000') + '/health/liveliness', timeout=4)" || exit 1
