#!/bin/bash

. test/assert.sh

STUBS=test/stubs
PATH="$STUBS:./:$PATH"
DOKKU_ROOT="test/fixtures/dokku"
dokku="PATH=$PATH DOKKU_ROOT=$DOKKU_ROOT commands"

# `persistent-storage` requires an app name
assert "$dokku persistent-storage" "You must specify an app name"
assert_raises "$dokku persistent-storage" 1

# `persistent-storage` requires an existing app
assert "$dokku persistent-storage foo" "App foo does not exist"
assert_raises "$dokku persistent-storage foo" 1

# `persistent-storage:add` requires an app name
assert "$dokku persistent-storage:add" "You must specify an app name"
assert_raises "$dokku persistent-storage:add" 1

# `persistent-storage:add` requires an existing app
assert "$dokku persistent-storage:add foo" "App foo does not exist"
assert_raises "$dokku persistent-storage:add foo" 1

# `persistent-storage:add` requires at least directory
assert "$dokku persistent-storage:add rad-app" "Usage: dokku persistent-storage:add <app> DIR_NAME [DIR_NAME2 ...]\nMust specify a DIRECTORY to persist."
assert_raises "$dokku persistent-storage:add rad-app" 1

# `persistent-storage:add` should write PERSISTENT_STORAGE file
assert "$dokku persistent-storage:add rad-app uploads" "Added \"uploads\" persistent storage to the application rad-app"
expected=$(< "test/expected/rad-app-PERSISTENT_STORAGE")
assert "cat test/fixtures/dokku/rad-app/PERSISTENT_STORAGE" "$expected"

# `persistent-storage` should read the set persistent-storage
assert "$dokku persistent-storage rad-app" "uploads"

# `persistent-storage:clear` should remove all storages
assert "$dokku persistent-storage:clear rad-app" "Removed all persistent storages"
assert "cat test/fixtures/dokku/rad-app/PERSISTENT_STORAGE" ""

# `persistent-storage:add` should add multiple folders
assert "$dokku persistent-storage:add rad-app uploads tmp/cache" "Added \"uploads\" persistent storage to the application rad-app\nAdded \"tmp/cache\" persistent storage to the application rad-app"
expected=$(< "test/expected/rad-app-PERSISTENT_STORAGE-second")
assert "cat test/fixtures/dokku/rad-app/PERSISTENT_STORAGE" "$expected"

# `persistent-storage` should read the set persistent-storage
assert "$dokku persistent-storage rad-app" "uploads\ntmp/cache"

# `persistent-storage:add` should write that the uploads already exists
assert "$dokku persistent-storage:add rad-app uploads" "The \"uploads\" is already configured as persistent storage"
expected=$(< "test/expected/rad-app-PERSISTENT_STORAGE-second")
assert "cat test/fixtures/dokku/rad-app/PERSISTENT_STORAGE" "$expected"

# `persistent-storage:remove` requires an app name
assert "$dokku persistent-storage:remove" "You must specify an app name"
assert_raises "$dokku persistent-storage:remove" 1

# `persistent-storage:remove` requires an existing app
assert "$dokku persistent-storage:remove foo" "App foo does not exist"
assert_raises "$dokku persistent-storage:remove foo" 1

# `persistent-storage:remove` requires at least directory
assert "$dokku persistent-storage:remove rad-app" "Usage: dokku persistent-storage:remove <app> DIR_NAME [DIR_NAME2 ...]\nMust specify a DIRECTORY to remove from persistent storage."
assert_raises "$dokku persistent-storage:remove rad-app" 1

# `persistent-storage:remove` should write that the directory is not configured to persist
assert "$dokku persistent-storage:remove rad-app foo" "The \"foo\" is not configured as persistent storage"
expected=$(< "test/expected/rad-app-PERSISTENT_STORAGE-second")
assert "cat test/fixtures/dokku/rad-app/PERSISTENT_STORAGE" "$expected"

# `persistent-storage:remove` should write that the directory is not configured to persist
assert "$dokku persistent-storage:remove rad-app tmp/cache" "Removed \"tmp/cache\" persistent storage from the application rad-app"
expected=$(< "test/expected/rad-app-PERSISTENT_STORAGE")
assert "cat test/fixtures/dokku/rad-app/PERSISTENT_STORAGE" "$expected"

# end of test suite
assert_end examples

echo -n "" > test/fixtures/dokku/rad-app/PERSISTENT_STORAGE
