#! /bin/bash

#
# Script to adjust the ruby load path, so we can execute bins in place.
#

base="$(readlink -f $(dirname $0))"
RUBYLIB="${base}/lib:${base}/../git_store/lib" "$@"


