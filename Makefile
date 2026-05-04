COMPOSE     = docker compose
SERVICE     = dev
UID         := $(shell id -u)
GID         := $(shell id -g)
DOCKER_RUN  = $(COMPOSE) run --rm --user $(UID):$(GID) -e HOME=/tmp $(SERVICE)

.PHONY: help build shell test test-cov lint type-check dist clean

help:
	@echo "Targets:"
	@echo "  build      - Build the Docker image"
	@echo "  shell      - Open an interactive shell in the container"
	@echo "  test       - Run all unit tests"
	@echo "  test-cov   - Run tests with HTML coverage report (./htmlcov/)"
	@echo "  lint       - Lint source and tests with ruff"
	@echo "  type-check - Type-check source with mypy"
	@echo "  dist       - Build release zip in ./dist/"
	@echo "  clean      - Remove all build/test artifacts"

build:
	$(COMPOSE) build

shell:
	$(DOCKER_RUN) /bin/bash

test:
	$(DOCKER_RUN) pytest tests/ -v

test-cov:
	$(DOCKER_RUN) pytest tests/ -v \
	    --cov=custom_components \
	    --cov-report=term-missing \
	    --cov-report=html

lint:
	$(DOCKER_RUN) ruff check src/ tests/

type-check:
	$(DOCKER_RUN) mypy src/

dist:
	$(DOCKER_RUN) bash /workspace/scripts/build.sh

clean:
	rm -rf dist/ .coverage htmlcov/ .mypy_cache/ .pytest_cache/
	find . -type d -name __pycache__ -exec rm -rf {} +
