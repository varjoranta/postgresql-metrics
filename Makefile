short_ver = $(shell grep -m 1 version setup.py | cut -d = -f 2 | tr -dc \'[:alnum:].\')
long_ver = $(shell git describe --long 2>/dev/null || echo $(short_ver)-0-g`git describe --always`)

PYTHON ?= python

all:
	: 'try "make deb" or "build-dep-deb"'

clean:
	rm -r *.egg-info/ build/ dist/
	rm ../postgresql-metrics_*

deb:
	echo build package with version: $(long_ver)
	cp debian/changelog.in debian/changelog
	dch -v $(long_ver) "Automatically built package"
	dpkg-buildpackage -A -uc -us

build-dep-deb:
	sudo apt-get install \
		build-essential debhelper \
		python-all python-setuptools python-psycopg2 libpq-dev
	sudo easy_install pip
	sudo pip install --upgrade ndg-httpsclient
	sudo pip install --upgrade dh-virtualenv

