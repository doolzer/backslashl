SHELL := /bin/bash -o pipefail -o errexit

PACKAGE = backslashl
VERSION ?= 0.0.1
PKGNAME = $(PACKAGE)-$(VERSION)

CONDA_PREFIX ?= target/conda

.PHONY: clean conda-build build

target:
	@mkdir -p $@

conda-build-dev: 
	@conda build -b --output-folder $(CONDA_LOCAL_FORGE) --label dev conda/dev

target/$(PKGNAME): env.sh src/backslashl.q
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
