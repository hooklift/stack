# Hooklift Runtime Stack
This is the rootfs used by all containers managed by Hooklift. It is based on Heroku's Cedar14 stack.

# Prerequisites
* Docker machine
* Docker

# Building and releasing
* `make stack`: Uses Docker to provision and runs `docker export` to capture the rootfs.

* `make release`: Uploads any distributable artifacts up to project's github releases.
