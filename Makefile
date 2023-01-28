SHELL := /bin/bash -o pipefail -o errexit


PACKAGE = backslashl
VERSION ?= 0.0.1
PKGNAME = $(PACKAGE)-$(VERSION)

CONDA_PREFIX ?= target/conda

.PHONY: clean conda-build build

target:
	@mkdir -p $@

target/conda-install.sh: target
	@curl -o $@ https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh

$(CONDA_PREFIX): target/conda-install.sh
	@sh target/conda-install.sh -p $@ -b

conda-build: $(CONDA_PREFIX)
	@$(CONDA_PREFIX)/bin/conda create -y -n $(PACKAGE)
	@$(CONDA_PREFIX)/bin/conda install -y -n $(PACKAGE) conda-build 
	@$(CONDA_PREFIX)/bin/conda build -n $(PACKAGE) -b --output-dir target .

target/$(PKGNAME): src/backslashl.q
	@mkdir -p $@
	@cp -r $^ $@

$(Q_BUILD_PATH)/$(PKGNAME): target/$(PKGNAME)
	@mkdir -p $@
	@cp -r target/$(PKGNAME)/* $@

target/$(PKGNAME).tar.gz: target/$(PKGNAME)
	@tar -zcvf $@ $^

build: $(Q_BUILD_PATH)/$(PKGNAME) target/$(PKGNAME).tar.gz
	rm -r target/$(PKGNAME)

clean: 
	@rm -r target
