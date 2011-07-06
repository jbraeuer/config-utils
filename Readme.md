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

## Usage

Document me.

## Known Bugs

* git_store can only read loose-objects (not packed ones)
* the working-copy is not updated
