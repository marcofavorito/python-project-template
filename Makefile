.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([0-9a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT


.PHONY: help
help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

.PHONY: clean
clean: clean-build clean-pyc clean-test clean-docs ## remove all build, test, coverage and Python artifacts

.PHONY: clean-build
clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

.PHONY: clean-pyc
clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

.PHONY: clean-docs
clean-docs:  ## remove MkDocs products.
	mkdocs build --clean
	rm -fr site/


.PHONY: clean-test
clean-test: ## remove test and coverage artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache
	rm -fr .mypy_cache
	rm -fr coverage.xml
	rm -fr .hypothesis

.PHONY: lint-all
lint-all: ruff-format ruff-check static bandit safety vulture ## run all linters

.PHONY: poetry-lock-check
poetry-lock-check: ## check if poetry.lock is consistent with pyproject.toml
	poetry check --lock

.PHONY: static
static: ## static type checking with mypy
	mypy

.PHONY: ruff-format
rufff: ## check ruff formatting
	ruff format --diff .

.PHONY: ruff-format-check
ruff-format: ## check ruff formatting
	ruff format .

.PHONY: ruff
ruff: ## run ruff linter
	ruff check --fix --show-fixes .

.PHONY: ruff-check
ruff-check: ## check ruff linter rules
	ruff check .

.PHONY: bandit
bandit: ## run bandit
	bandit -c .bandit.yaml -r python_project_template tests scripts examples

.PHONY: safety
safety: ## run safety
	safety check

.PHONY: vulture
vulture: ## run vulture
	vulture python_project_template scripts/whitelist.py

.PHONY: test
test: ## run tests quickly with the default Python
	pytest tests python_project_template \
        --doctest-modules \
        --cov=python_project_template \
        --cov-report=xml \
        --cov-report=html \
        --cov-report=term

.PHONY: test-all
test-all: ## run tests on every Python version with tox
	tox

.PHONY: coverage
coverage: ## check code coverage quickly with the default Python
	coverage run --source python_project_template -m pytest
	coverage report -m
	coverage html
	$(BROWSER) htmlcov/index.html

.PHONY: docs
docs: ## generate MkDocs HTML documentation, including API docs
	mkdocs build --clean

.PHONY: servedocs
servedocs: docs ## compile the docs watching for changes
	mkdocs build --clean
	python -c 'print("###### Starting local server. Press Control+C to stop server ######")'
	mkdocs serve

.PHONY: release
release: dist ## package and upload a release
	twine upload dist/*

.PHONY: dist
dist: clean ## builds source and wheel package
	poetry build
	ls -l dist
