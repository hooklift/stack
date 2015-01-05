NAME 		:= stack
VERSION 	:= v1.0.0
OK_COLOR 	:= \x1b[32;01m
NO_COLOR    	:= \x1b[0m

stack:
	rm -rf dist && mkdir dist
	@echo "$(OK_COLOR)------> Building Hooklift stack image...$(NO_COLOR)"
	docker build --force-rm=true -t hooklift/$(NAME) .
	@echo "$(OK_COLOR)------> Running image so that we can export it...$(NO_COLOR)"
	docker run --name $(NAME)-build -e DEBIAN_FRONTEND=noninteractive hooklift/$(NAME)
	@echo "$(OK_COLOR)------> Exporting stack...$(NO_COLOR)"
	docker export $(NAME)-build > dist/hooklift-$(NAME).tar
	@echo "$(OK_COLOR)------> Compressing rootfs...$(NO_COLOR)"
	gzip -c dist/hooklift-$(NAME).tar > dist/hooklift-$(NAME)-$(VERSION).tar.gz
	rm -rf dist/hooklift-$(NAME).tar
	docker stop $(NAME)-build
	docker rm $(NAME)-build
	@#docker rmi hooklift/$(NAME)

deps:
	go get -u github.com/c4milo/github-release/...

digest:
	@echo "$(OK_COLOR)-----> Generating SHA512 digest...$(NO_COLOR)"
	$(eval FILES := $(shell ls dist))
	@for f in $(FILES); do \
		(cd $(shell pwd)/dist && shasum -a 512 $$f > $$f.sha512); \
		echo $$f; \
	done

release: stack digest
	@latest_tag=$$(git describe --tags `git rev-list --tags --max-count=1`); \
	comparison="$$latest_tag..HEAD"; \
	if [ -z "$$latest_tag" ]; then comparison=""; fi; \
	changelog=$$(git log $$comparison --oneline --no-merges --reverse); \
	github-release hooklift/$(NAME) $(VERSION) "$$(git rev-parse --abbrev-ref HEAD)" "**Changelog**<br/>$$changelog" 'dist/*'; \
	git pull

.PHONY: deps release stack digest
