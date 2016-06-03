OK_COLOR	:= \x1b[32;01m
NO_COLOR	:= \x1b[0m

STACKS=cedar-14 lift-16
VERSION=v1.1.1

build:
	@$(foreach C, $(STACKS), $(MAKE) -C $(C) build &&) echo done

cedar14:
	@$(MAKE) -C cedar-14 build

lift16:
	@$(MAKE) -C lift-16 build

deps:
	go get -u github.com/c4milo/github-release/...

digest:
	@echo "$(OK_COLOR)-----> Generating SHA512 digest...$(NO_COLOR)"
	$(eval FILES := $(shell ls dist/*.tar.gz))
	@for f in $(FILES); do \
		(cd $(shell pwd)/dist && shasum -a 512 $$f > $$f.sha512); \
		echo $$f; \
	done

release: build digest
	@latest_tag=$$(git describe --tags `git rev-list --tags --max-count=1`); \
	comparison="$$latest_tag..HEAD"; \
	if [ -z "$$latest_tag" ]; then comparison=""; fi; \
	changelog=$$(git log $$comparison --oneline --no-merges --reverse); \
	github-release hooklift/stack $(VERSION) "$$(git rev-parse --abbrev-ref HEAD)" "**Changelog**<br/>$$changelog" 'dist/*'; \
	git pull

.PHONY: deps release build digest cedar14 lift16
