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

Initialize the store.
    ./kv --store /path/to/repo --init

Set a value
    ./kv --store /path/to/repo --set mykey=myvalue

Get a value
  Print <key>=<value>
    ./kv --store /path/to/repo --get mykey
  Get a value from withing a shell script
    value=$(./kv --store /path/to/repo --get mykey --raw)

Add value to list
    ./kv --store /path/to/repo --append mykey=anothervalue

Delete keys/value
  Delete key with all its values
    ./kv --store /path/to/repo --del mykey
  Delete elements
    ./kv --store /path/to/repo --del mykey=element

List operations
    ./kv --store /path/to/repo --listkeys
    ./kv --store /path/to/repo --list
