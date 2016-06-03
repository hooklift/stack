# Hooklift Runtime Stacks
Officially supported root filesystems used by all containers managed by Hooklift.

# Prerequisites
* Docker machine
* Docker

# Building and releasing
* `make build`: Builds all the stacks
* `make cedar14`: Builds Heroku's cedar-14 stack
* `make lift16`: Builds Hooklift's stack
* `make release`: Uploads any distributable artifacts up to project's github releases.
