#!/usr/bin/env python3
# This file is part of python-project-template.
# Copyright 2024 Marco Favorito
#
# python-project-template is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# python-project-template is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with python-project-template.  If not, see <https://www.gnu.org/licenses/>.
#

"""Update dependency versions in pyproject.toml and tox.ini."""

import json
import re
import ssl
import sys
import urllib.request
from pathlib import Path

VERSION_INFO_URL = "https://pypi.org/pypi/{}/json"
IGNORE = {"ipython", "tox"}


def get_latest_version(package_name: str) -> str:
    """Get latest version of package_name from PyPI."""
    url = VERSION_INFO_URL.format(package_name)
    ssl_context = ssl.create_default_context()
    with urllib.request.urlopen(url, context=ssl_context) as response:  # noqa: S310  # nosec S310
        data = json.load(response)
        return data["info"]["version"]


if __name__ == "__main__":
    pyprojecttoml = Path("pyproject.toml")
    toxini = Path("tox.ini")
    pyprojecttoml_content = pyprojecttoml.read_text(encoding="utf-8")
    toxini_content = toxini.read_text(encoding="utf-8")

    # replace in pyproject.toml
    matches = re.findall(
        '^([a-zA-Z0-9_-]+) += +"==(.*)"', pyprojecttoml_content, re.MULTILINE
    )
    for package_name, version in matches:
        if package_name in IGNORE:
            continue
        latest_version = get_latest_version(package_name)
        if version != latest_version:
            print(f"Updating {package_name} from {version} to {latest_version}")
            pyprojecttoml_content = re.sub(
                f'(?:^|(?<=\\W)){package_name} *= *"=={version}"',
                f'{package_name} = "=={latest_version}"',
                pyprojecttoml_content,
            )
            toxini_content = re.sub(
                f"(?:^|(?<=\\W)){package_name} *== *{version}",
                f"{package_name}=={latest_version}",
                toxini_content,
            )

    pyprojecttoml.write_text(pyprojecttoml_content)
    toxini.write_text(toxini_content)
    print("Done!")
    sys.exit(0)
