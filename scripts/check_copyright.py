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

"""Check that all the Python files of the repository have the copyright notice.

In particular:
- (optional) the Python shebang
- the encoding header;
- the copyright and license notices;

It is assumed the script is run from the repository root.
"""

import itertools
import re
import sys
from pathlib import Path

COPYRIGHT_NOTICE = "Copyright 2024 Marco Favorito"
HEADER_REGEX = re.compile(
    rf"""(#!/usr/bin/env python3
)?# This file is part of python-project-template\.
# {COPYRIGHT_NOTICE}
#
# python-project-template is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# \(at your option\) any later version\.
#
# python-project-template is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE\.  See the
# GNU General Public License for more details\.
#
# You should have received a copy of the GNU General Public License
# along with python-project-template\.  If not, see <https://www\.gnu\.org/licenses/>\.
#""",
    re.MULTILINE,
)


def check_copyright(file: Path) -> bool:
    """Given a file, check if the header stuff is in place.

    Return True if the files has the encoding header and the copyright notice,
    optionally prefixed by the shebang. Return False otherwise.

    :param file: the file to check.
    :return: True if the file is compliant with the checks, False otherwise.
    """
    content = file.read_text()
    return re.match(HEADER_REGEX, content) is not None


def check_copyright_in_readme() -> bool:
    """Check if the README.md contains the right copyright notice."""
    readme_filepath = Path("README.md").resolve()
    if not readme_filepath.exists():
        msg = f"README file {readme_filepath} does not exist"
        raise ValueError(msg)
    readme_content = readme_filepath.read_text()
    matches = re.findall("Copyright .*", readme_content)
    if len(matches) == 0:
        return False
    for match in matches:
        if match != COPYRIGHT_NOTICE:
            return False
    print("README is OK.")
    return True


def check_copyright_headers() -> bool:
    """Check copyright headers are correct."""
    exclude_files = {Path("scripts", "whitelist.py")}
    python_files = filter(
        lambda x: x not in exclude_files,
        itertools.chain(
            Path("python_project_template").glob("**/*.py"),
            Path("tests").glob("**/*.py"),
            Path("scripts").glob("**/*.py"),
        ),
    )

    bad_files = []
    for filepath in python_files:
        print(f"Checking file {filepath}...", end=" ")
        result = check_copyright(filepath)
        if result:
            print("OK")
        else:
            print("FAIL")
            bad_files.append(filepath)

    if len(bad_files) > 0:
        print("The following files are not well formatted:")
        print("\n".join(map(str, bad_files)))
        return False
    return True


if __name__ == "__main__":
    result: bool = check_copyright_headers()
    result = result and check_copyright_in_readme()
    if not result:
        sys.exit(1)
    print("All checks have passed!")
    sys.exit(0)
