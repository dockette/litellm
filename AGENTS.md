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
  The default value must build correctly without any `--build-arg`, because the
  shared workflow in `dockette/.github` cannot pass build arguments.
- A version bump touches three places: the `ARG` default, `LITELLM_VERSION` in the
  `Makefile`, and the `tag` matrix in `.github/workflows/docker.yml`.
- Pillow is not pinned. A rebuild picks up the current release.
- There is no `curl` and no `wget` in the image. Use `python` for HTTP checks.
- `make test` checks the image contents. `make test-docker` starts the proxy.
- Run `make build test test-docker` before you commit.
