<h1 align="center">
  <b>(yet another) Python project template</b>
</h1>

<p align="center">
  <a href="https://pypi.org/project/python-project-template">
    <img alt="PyPI" src="https://img.shields.io/pypi/v/python-project-template">
  </a>
  <a href="https://pypi.org/project/python-project-template">
    <img alt="PyPI - Python Version" src="https://img.shields.io/pypi/pyversions/python-project-template" />
  </a>
  <a href="">
    <img alt="PyPI - Status" src="https://img.shields.io/pypi/status/python-project-template" />
  </a>
  <a href="">
    <img alt="PyPI - Implementation" src="https://img.shields.io/pypi/implementation/python-project-template">
  </a>
  <a href="">
    <img alt="PyPI - Wheel" src="https://img.shields.io/pypi/wheel/python-project-template">
  </a>
  <a href="https://github.com/marcofavorito/python-project-template/blob/master/LICENSE">
    <img alt="GitHub" src="https://img.shields.io/github/license/marcofavorito/python-project-template">
  </a>
  <a href="https://github.com/pre-commit/pre-commit"><img src="https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit" alt="pre-commit" style="max-width:100%;"></a>
</p>
<p align="center">
  <a href="">
    <img alt="test" src="https://github.com/marcofavorito/python-project-template/workflows/test/badge.svg">
  </a>
  <a href="">
    <img alt="lint" src="https://github.com/marcofavorito/python-project-template/workflows/lint/badge.svg">
  </a>
  <a href="">
    <img alt="docs" src="https://github.com/marcofavorito/python-project-template/workflows/docs/badge.svg">
  </a>
  <a href="https://codecov.io/gh/marcofavorito/python-project-template">
    <img alt="codecov" src="https://codecov.io/gh/marcofavorito/python-project-template/branch/master/graph/badge.svg?token=FG3ATGP5P5">
  </a>
</p>


Yet another Python project template.

## Install

(TODO replace) To install the package from PyPI:
```
pip install python_project_template
```

## Development

Clone the repository:
```
git clone https://github.com/marcofavorito/python-project-template
cd python-project-template
```

Set up virtual environment using [Poetry](https://python-poetry.org/):
```
poetry shell
poetry install
```

## Tests

To run tests: `tox`

To run only the code tests: `tox -e py311`

To run only the linters:
- `tox -e flake8`
- `tox -e mypy`
- `tox -e black-check`
- `tox -e isort-check`

Please look at the `tox.ini` file for the full list of supported commands.

## Docs

To build the docs: `mkdocs build`

To view documentation in a browser: `mkdocs serve`
and then go to [http://localhost:8000](http://localhost:8000)

## License

python-project-template is released under the GNU General Public License v3.0 or later (GPLv3+).

Copyright 2024 Marco Favorito

## Authors

- [Marco Favorito](https://marcofavorito.me/)
