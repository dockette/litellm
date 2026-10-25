# AGENTS.md

LiteLLM Proxy Docker image, published as `dockette/litellm`.

## Writing style

- Write in ASD-STE100 (Simplified Technical English).
- Follow Zinsser's four principles of quality writing:
  1. Simplicity
  2. Brevity
  3. Clarity
  4. Humanity

## Conventions

- The image only adds `pip` and Pillow to the upstream image. Keep it that way.
- Do not override the upstream entrypoint, command, workdir or exposed port.
- The upstream version is pinned in `ARG LITELLM_VERSION` in the `Dockerfile`.
  The default value must build correctly without any `--build-arg`, because CI
  passes no build arguments.
- A version bump touches the `ARG` default, `LITELLM_VERSION` in `VERSION`
  and the table in `README.md`. CI reads the tags from `VERSION`.
- Pillow is not pinned. A rebuild picks up the current release.
- `curl` is installed on top of the upstream image. The healthcheck uses it.
- `VERSION` holds the release date and `LITELLM_VERSION`; `make release` sets
  the date. CI pushes `latest` also as `<VERSION>`, `<LITELLM_VERSION>` and
  `<LITELLM_VERSION>-<VERSION>`, and creates the GitHub release.
- CI builds every branch. Only master is pushed to Docker Hub.
- `make test` checks the image contents. `make test-docker` starts the proxy.
- Run `make build test test-docker` before you commit.
