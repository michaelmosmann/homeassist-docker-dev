COMPOSE  = docker compose
SERVICE  = dev

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
	$(COMPOSE) run --rm $(SERVICE) /bin/bash

test:
	$(COMPOSE) run --rm $(SERVICE) pytest tests/ -v

test-cov:
	$(COMPOSE) run --rm $(SERVICE) pytest tests/ -v \
	    --cov=custom_components \
	    --cov-report=term-missing \
	    --cov-report=html

lint:
	$(COMPOSE) run --rm $(SERVICE) ruff check src/ tests/

type-check:
	$(COMPOSE) run --rm $(SERVICE) mypy src/

dist:
	$(COMPOSE) run --rm $(SERVICE) bash /workspace/scripts/build.sh

clean:
	rm -rf dist/ .coverage htmlcov/ .mypy_cache/ .pytest_cache/
	find . -type d -name __pycache__ -exec rm -rf {} +
