.PHONY: clean clean-test clean-pyc clean-build docs help
.DEFAULT_GOAL := help

define BROWSER_PYSCRIPT
import os, webbrowser, sys

try:
	from urllib import pathname2url
except:
	from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

BROWSER := python -c "$$BROWSER_PYSCRIPT"

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

clean: clean-build clean-pyc clean-test clean-docs ## remove all build, test, coverage and Python artifacts

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-docs:  ## remove MkDocs products.
	mkdocs build --clean
	rm -fr site/


clean-test: ## remove test and coverage artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache
	rm -fr .mypy_cache
	rm -fr coverage.xml

lint-all: black isort lint static bandit safety vulture darglint pylint ## run all linters

lint: ## check style with flake8
	flake8 python_project_template tests scripts

static: ## static type checking with mypy
	mypy python_project_template tests scripts

isort: ## sort import statements with isort
	isort python_project_template tests scripts

isort-check: ## check import statements order with isort
	isort --check-only python_project_template tests scripts

black: ## apply black formatting
	black python_project_template tests scripts

black-check: ## check black formatting
	black --check --verbose python_project_template tests scripts

bandit: ## run bandit
	bandit python_project_template tests scripts

safety: ## run safety
	safety check

pylint: ## run pylint
	pylint python_project_template tests scripts

vulture: ## run vulture
	vulture python_project_template scripts/whitelist.py

darglint: ## run vulture
	darglint python_project_template

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


test-all: ## run tests on every Python version with tox
	tox

coverage: ## check code coverage quickly with the default Python
	coverage run --source python_project_template -m pytest
	coverage report -m
	coverage html
	$(BROWSER) htmlcov/index.html

docs: ## generate MkDocs HTML documentation, including API docs
	mkdocs build --clean
	$(BROWSER) site/index.html

servedocs: docs ## compile the docs watching for changes
	mkdocs build --clean
	python -c 'print("###### Starting local server. Press Control+C to stop server ######")'
	mkdocs serve

release: dist ## package and upload a release
	twine upload dist/*

dist: clean ## builds source and wheel package
	poetry build
	ls -l dist

install: clean ## install the package to the active Python's site-packages
	poetry install

develop: clean ## install the package in development mode
	echo "Not supported by Poetry yet!"
