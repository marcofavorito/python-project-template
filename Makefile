.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
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
	find . -name ".coverage*" -not -name ".coveragerc" -exec rm -fr "{}" \;
	rm -fr htmlcov/
	rm -fr .pytest_cache
	rm -fr .mypy_cache
	rm -fr coverage.xml
	rm -fr .hypothesis

.PHONY: lint-all
lint-all: black isort lint static bandit safety vulture darglint pylint ## run all linters

.PHONY: format ## run code formatters (isort and black)
format:
	tox -e isort
	tox -e black

.PHONY: check-code ## run several code checks (linting and static typing)
check-code:
	tox -p -e black-check -e isort-check -e flake8 -e mypy -e pylint -e vulture -e darglint

.PHONY: security ## checks dependencies for known security vulnerabilities
security:
	tox -p -e safety -e bandit

.PHONY: test
test: ## run tests quickly with the default Python
	pytest tests --doctest-modules \
        python_project_template tests/ \
        --cov=python_project_template \
        --cov-report=xml \
        --cov-report=html \
        --cov-report=term

# how to use:
#
#     make test-sub tdir=$TDIR dir=$DIR
#
# where:
# - TDIR is the path to the test module/directory (but without the leading "test_")
# - DIR is the *dotted* path to the module/subpackage whose code coverage needs to be reported.
#
# For example, to run the loss function tests (in tests/test_losses)
# and check the code coverage of the package python_project_template.some_package:
#
#     make test-sub tdir=some_package dir=python_project_template.some_package
#
.PHONY: test-sub
test-sub:
	pytest -rfE tests/test_$(tdir) --cov=python_project_template.$(dir) --cov-report=html --cov-report=xml --cov-report=term-missing --cov-report=term  --cov-config=.coveragerc
	find . -name ".coverage*" -not -name ".coveragerc" -exec rm -fr "{}" \;

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
	$(BROWSER) site/index.html

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
