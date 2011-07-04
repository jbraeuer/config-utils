# config-utils #

Config-utils is/will be a bunch of script to store simple key/value pairs. Config-utils can be used from shell-scripts.

Usecases are

* store user preferences
* store state between script-invokations
* render ERB templates based on the stored values

## Current state ##

* get,set,add,delete and list-operations work
* template rendering still missing

## Installation ##

Config-utils require git_store and grit. Both can be found on github.

## Usage ##

### Initialize the store.

    ./kv --store /path/to/repo --init

### Set a value

    ./kv --store /path/to/repo --set mykey=myvalue

### Get a value

  Print key=value

    ./kv --store /path/to/repo --get mykey

  Get a value from withing a shell script

    value=$(./kv --store /path/to/repo --get mykey --raw)

### Add value to list

    ./kv --store /path/to/repo --append mykey=anothervalue

### Delete keys/value

  Delete key with all its values

    ./kv --store /path/to/repo --del mykey

  Delete elements by exact match

    ./kv --store /path/to/repo --del mykey=element

  Delete all elements matching regexp

    ./kv --store /path/to/repo --del mykey=/myregexp/

### List operations

    ./kv --store /path/to/repo --listkeys
    ./kv --store /path/to/repo --list

### General options

  Separator to use for lists

    ./kv --separator

  Output raw-format (value only)

    ./kv --raw

  Git commit message to use

    ./kv --message

## Known Bugs

* git_store can only read loose-objects (not packed ones)
* the working-copy is not updated
