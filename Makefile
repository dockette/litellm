DOCKER_IMAGE=dockette/litellm
DOCKER_TAG?=latest
DOCKER_PLATFORMS?=linux/amd64,linux/arm64

LITELLM_VERSION?=v1.98.0
LITELLM_PORT?=14000
LITELLM_MASTER_KEY?=sk-dockette

TEST_RUN=docker run --rm --entrypoint /app/.venv/bin/python ${DOCKER_IMAGE}:${DOCKER_TAG}

.PHONY: build
build:
	docker build \
		--build-arg LITELLM_VERSION=${LITELLM_VERSION} \
		-t ${DOCKER_IMAGE}:${DOCKER_TAG} \
		.

.PHONY: push
push:
	docker buildx build \
		--platform ${DOCKER_PLATFORMS} \
		--build-arg LITELLM_VERSION=${LITELLM_VERSION} \
		-t ${DOCKER_IMAGE}:${DOCKER_TAG} \
		--push \
		.

.PHONY: run
run:
	docker run --rm -it \
		-p ${LITELLM_PORT}:4000 \
		-e LITELLM_MASTER_KEY=${LITELLM_MASTER_KEY} \
		${DOCKER_IMAGE}:${DOCKER_TAG}

.PHONY: shell
shell:
	docker run --rm -it --entrypoint /bin/sh ${DOCKER_IMAGE}:${DOCKER_TAG}

.PHONY: test
test: _testcase-curl _testcase-pip _testcase-pillow _testcase-codecs _testcase-litellm

# Smoke test: start the image, wait for the proxy, check Pillow inside it
.PHONY: test-docker
test-docker:
	IMAGE=${DOCKER_IMAGE}:${DOCKER_TAG} PORT=${LITELLM_PORT} ./tests/smoke.sh

.PHONY: _testcase-curl
_testcase-curl:
	docker run --rm --entrypoint curl ${DOCKER_IMAGE}:${DOCKER_TAG} --version

.PHONY: _testcase-pip
_testcase-pip:
	${TEST_RUN} -m pip --version

.PHONY: _testcase-pillow
_testcase-pillow:
	${TEST_RUN} -c "from PIL import Image; print('Pillow', Image.__version__)"

.PHONY: _testcase-codecs
_testcase-codecs:
	${TEST_RUN} -c "import sys; from PIL import features; missing = [c for c in ('jpg', 'zlib', 'webp', 'avif') if not features.check(c)]; print('codecs missing:', missing); sys.exit(1 if missing else 0)"

.PHONY: _testcase-litellm
_testcase-litellm:
	${TEST_RUN} -c "from importlib.metadata import version; print('litellm', version('litellm'))"
