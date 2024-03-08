.PHONY: clean quality requirements validate

clean:
	find . -name '__pycache__' -exec rm -rf {} +
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +	
	coverage erase
	rm -rf coverage htmlcov
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info

test.start_elasticsearch:
	docker-compose up -d

quality:
	pycodestyle --config=.pep8 manage.py search edxsearch/settings.py setup.py
	pylint --rcfile=pylintrc manage.py search edxsearch/settings.py setup.py
	pylint --py3k --rcfile=pylintrc manage.py msearch edxsearch/settings.py setup.py

requirements:
	pip install -r requirements/dev.txt

validate: clean
	tox


upgrade: export CUSTOM_COMPILE_COMMAND=make upgrade
upgrade: ## update the requirements/*.txt files with the latest packages satisfying requirements/*.in
	pip install -qr requirements/pip-tools.txt
	# Make sure to compile files after any other files they include!
	pip-compile --rebuild --upgrade --allow-unsafe --rebuild -o requirements/pip.txt requirements/pip.in
	pip-compile --rebuild --upgrade -o requirements/pip-tools.txt requirements/pip-tools.in
	pip-compile --rebuild --upgrade -o requirements/base.txt requirements/base.in
	pip-compile --rebuild --upgrade -o requirements/testing.txt requirements/testing.in
	pip-compile --rebuild --upgrade -o requirements/quality.txt requirements/quality.in
	pip-compile --rebuild --upgrade -o requirements/ci.txt requirements/ci.in
	pip-compile --rebuild --upgrade -o requirements/dev.txt requirements/dev.in

test:
	python -Wd -m coverage run manage.py test --settings=edxsearch.settings
	pytest -k search.tests.test_utils
