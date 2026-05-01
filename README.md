# homeassist-docker-dev

A Docker-based development environment for building and testing Home Assistant custom integrations in Python. Nothing needs to be installed on the host machine beyond Docker.

## Structure

```
├── Dockerfile               # Python 3.12-slim + all HA dev deps
├── docker-compose.yml       # mounts the whole repo into /workspace
├── Makefile                 # convenience targets
├── pyproject.toml           # pytest / ruff / mypy config
├── requirements.txt         # your extension's runtime deps (start empty)
├── requirements-dev.txt     # HA test framework, pytest, ruff, mypy
├── scripts/build.sh         # produces dist/<name>-<version>.zip
├── src/custom_components/
│   └── my_integration/      # rename this to your integration domain
│       ├── manifest.json
│       ├── const.py
│       ├── __init__.py
│       └── sensor.py
└── tests/
    ├── conftest.py           # loads pytest-homeassistant-custom-component
    └── test_sensor.py        # example tests using MockConfigEntry + hass fixture
```

## Workflow

```bash
# First time — builds the image (takes a few minutes, downloads HA)
make build

# Run all tests
make test

# Run tests with HTML coverage report (→ ./htmlcov/index.html)
make test-cov

# Lint with ruff / type-check with mypy
make lint
make type-check

# Build release artifact → ./dist/my_integration-0.1.0.zip
make dist

# Drop into a shell for interactive work
make shell
```

## Creating your own extension

1. Rename `src/custom_components/my_integration/` to your integration domain
2. Update `manifest.json` (domain, name, version, requirements)
3. Update `const.py` with your `DOMAIN`
4. Add your platform files (`sensor.py`, `binary_sensor.py`, etc.)
5. Write tests in `tests/` — the `hass` and `MockConfigEntry` fixtures come from `pytest-homeassistant-custom-component`

The version in `manifest.json` drives the release artifact filename — bump it before running `make dist`.
