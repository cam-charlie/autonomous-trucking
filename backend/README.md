# Python Setup Instructions

Firstly, set up a virtual enviroment with the following command:

`python3 -m venv env`

Next, activate it with:

`source env/bin/activate`

Finally, install the requirements with:

`pip install -r requirements.txt`

To leave the virtual enviroment, run:

`deactivate`

# Using packages

If you install any packages during development, make sure to add them to the requirements.txt

# Running mypy and pylint

mypy:

`mypy .`

pylint:

`pylint --rcfile=pylint.cfg --recursive=y simulation test`