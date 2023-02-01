#!/usr/bin/env bash

export QLIC=$(dirname $KCLIC)
export QINIT=$(readlink -f $(find $(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd) -maxdepth 2 -name backslashl.q))
