ARG LITELLM_VERSION=v1.98.0

FROM ghcr.io/berriai/litellm:${LITELLM_VERSION}

LABEL maintainer="sulcmil@gmail.com"

# CURL #########################################################################
# The upstream image has no HTTP client.
RUN apk add --no-cache curl

# PIP ##########################################################################
# The upstream image ships a virtualenv at /app/.venv without pip.
RUN /app/.venv/bin/python -m ensurepip --upgrade && \
    /app/.venv/bin/python -m pip install --no-cache-dir --upgrade pip

# PILLOW #######################################################################
RUN /app/.venv/bin/python -m pip install --no-cache-dir Pillow && \
    /app/.venv/bin/python -c "from PIL import Image; print(Image.__version__)"

# HEALTHCHECK ##################################################################
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
    CMD curl -fsS "http://127.0.0.1:${PORT:-4000}/health/liveliness" || exit 1
