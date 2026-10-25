<h1 align=center>Dockette / LiteLLM</h1>

<p align=center>
   🎁 LiteLLM Proxy with preinstalled pip and Pillow.
</p>

<p align=center>
🕹 <a href="https://f3l1x.io">f3l1x.io</a> | 💻 <a href="https://github.com/f3l1x">f3l1x</a> | 🐦 <a href="https://twitter.com/xf3l1x">@xf3l1x</a>
</p>

<p align=center>
  <a href="https://github.com/dockette/litellm/actions"><img src="https://github.com/dockette/litellm/actions/workflows/docker.yml/badge.svg"></a>
  <a href="https://hub.docker.com/r/dockette/litellm/"><img src="https://badgen.net/docker/pulls/dockette/litellm"></a>
  <a href="https://github.com/sponsors/f3l1x"><img src="https://badgen.net/badge/sponsor/donations/F96854"></a>
  <a href="https://github.com/orgs/dockette/discussions"><img src="https://badgen.net/badge/support/discussions/blue"></a>
</p>

------

[LiteLLM](https://github.com/BerriAI/litellm) Proxy with `pip` and [Pillow](https://python-pillow.github.io) added to the
application virtualenv. The upstream image is built on Wolfi and ships a virtualenv at `/app/.venv` without `pip`.
LiteLLM imports Pillow for image handling (Bedrock, Vertex AI and Ollama), but does not install it. There is also no HTTP
client. This image fills all three gaps.

## Features

- LiteLLM Proxy `v1.104.0`
- Python 3.13 (upstream virtualenv at `/app/.venv`)
- `pip` installed and upgraded, so you can add packages at runtime
- Pillow preinstalled (JPEG, PNG, WEBP, AVIF, GIF and TIFF)
- `curl` installed
- Healthcheck on `/health/liveliness`, done with `curl`
- Entrypoint, command, workdir and exposed port are inherited from upstream

## Usage

```sh
docker run --rm -it -p 4000:4000 -e LITELLM_MASTER_KEY=sk-1234 dockette/litellm:latest
```

```sh
# With a configuration file
docker run --rm -it -p 4000:4000 -e LITELLM_MASTER_KEY=sk-1234 -v $(pwd)/config.yaml:/app/config.yaml dockette/litellm:latest --config /app/config.yaml --port 4000

# Add more Python packages at runtime
docker exec -it <container> /app/.venv/bin/python -m pip install <package>
```

## Configuration

- `LITELLM_MASTER_KEY` - master key of the proxy
- `PORT` - port used by the healthcheck, `4000` by default

The default command is `--port 4000`. This argument wins over `PORT`. Set both if you change the port.

The working directory is `/app`. The user is `root`, same as upstream.

## Versions

| Version | Release |
|---------|---------|
| `dockette/litellm:v1.104.0-YYYY.MM.DD` | LiteLLM `v1.104.0` in release `YYYY.MM.DD`; pin this one |
| `dockette/litellm:v1.104.0` | latest release with LiteLLM `v1.104.0` |
| `dockette/litellm:YYYY.MM.DD` | release `YYYY.MM.DD` |
| `dockette/litellm:latest` | latest build of `master` |

All versions build on `ghcr.io/berriai/litellm:v1.104.0`. Pillow is installed at build time and is not pinned, so a
rebuild can ship a newer Pillow. Releases are listed on [GitHub](https://github.com/dockette/litellm/releases).

## Development

```sh
make build          # build the image
make test           # check curl, pip, Pillow, codecs and LiteLLM
make test-docker    # start the image and check the proxy
make run            # run the proxy on port 14000
make shell          # open a shell in the image
make push           # build and push linux/amd64 and linux/arm64
make version        # print VERSION
make release        # set today's date in VERSION

# Build against another LiteLLM release
make build LITELLM_VERSION=v1.97.0
```

## Maintenance

See [how to contribute](https://github.com/dockette/.github/blob/master/CONTRIBUTING.md) to this package. Consider to
[support](https://github.com/sponsors/f3l1x) **f3l1x**. Thank you for using this package.
