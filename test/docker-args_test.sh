#!/bin/bash

. test/assert.sh

STUBS=test/stubs
PATH="$STUBS:./:$PATH"
DOKKU_ROOT="test/fixtures/dokku"
docker_args="PATH=$PATH DOKKU_ROOT=$DOKKU_ROOT docker-args"

# `docker-args` shouldn't do anything if the app doesn't have any PERSISTENT_STORAGES
assert "$docker_args empty-app" ""

# `docker-args` should return docker options for each directory
assert "$docker_args nifty-app" " -v $DOKKU_ROOT/nifty-app/.storages/uploads:/app/uploads"
assert_raises "[ -d $DOKKU_ROOT/nifty-app/.storages/uploads ]" 0

assert "$docker_args multi-app" " -v $DOKKU_ROOT/multi-app/.storages/uploads:/app/uploads -v $DOKKU_ROOT/multi-app/.storages/tmp/cache:/app/tmp/cache"
assert_raises "[ -d $DOKKU_ROOT/multi-app/.storages/uploads ]" 0
assert_raises "[ -d $DOKKU_ROOT/multi-app/.storages/tmp/cache ]" 0

# end of test suite
assert_end examples

echo -n "" > test/fixtures/dokku/rad-app/PERSISTENT_STORAGE
# rm -r $DOKKU_ROOT/nifty-app/.storages
