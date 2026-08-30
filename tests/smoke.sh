#!/usr/bin/env sh
# Smoke test for the image. Usage: IMAGE=dockette/litellm:latest PORT=14000 ./tests/smoke.sh
set -eu

IMAGE="${IMAGE:-dockette/litellm:latest}"
PORT="${PORT:-14000}"
NAME="${NAME:-litellm-smoke}"
TIMEOUT="${TIMEOUT:-90}"

cleanup() {
    docker rm -f "$NAME" > /dev/null 2>&1 || true
}
trap cleanup EXIT INT TERM

cleanup

echo "> start ${IMAGE} on port ${PORT}"
docker run -d --name "$NAME" \
    -p "${PORT}:4000" \
    -e LITELLM_MASTER_KEY=sk-smoke \
    "$IMAGE" > /dev/null

echo "> wait for http://127.0.0.1:${PORT}/health/liveliness"
i=0
until curl -fsS "http://127.0.0.1:${PORT}/health/liveliness" > /dev/null 2>&1; do
    i=$((i + 1))
    if [ "$i" -ge "$TIMEOUT" ]; then
        echo "! proxy did not start" >&2
        docker logs "$NAME" >&2
        exit 1
    fi
    sleep 1
done

echo "> health/liveliness"
curl -fsS "http://127.0.0.1:${PORT}/health/liveliness" | grep -q "alive" \
    || { echo "! liveliness did not report alive" >&2; exit 1; }

echo "> health/readiness"
curl -fsS "http://127.0.0.1:${PORT}/health/readiness" | grep -q '"status"' \
    || { echo "! readiness did not answer" >&2; exit 1; }

echo "> Pillow in the running container"
docker exec "$NAME" /app/.venv/bin/python -c "from PIL import Image; print('Pillow', Image.__version__)"

echo "> docker healthcheck"
i=0
until [ "$(docker inspect --format '{{.State.Health.Status}}' "$NAME")" = "healthy" ]; do
    i=$((i + 1))
    if [ "$i" -ge "$TIMEOUT" ]; then
        echo "! container did not become healthy" >&2
        docker inspect --format '{{json .State.Health}}' "$NAME" >&2
        exit 1
    fi
    sleep 1
done

echo "> ok"
