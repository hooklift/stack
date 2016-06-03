OK_COLOR	:= \x1b[32;01m
NO_COLOR	:= \x1b[0m
PACKAGE		:= hooklift-$(NAME)-$(VERSION).tar.gz
DIST		:= ../dist

build:
	rm -rf $(DIST)/$(PACKAGE)*
	@echo "$(OK_COLOR)------> Building Hooklift $(NAME) image...$(NO_COLOR)"
	docker build --force-rm=true -t hooklift/$(NAME) .
	@echo "$(OK_COLOR)------> Running image so we can export it...$(NO_COLOR)"
	docker run --name $(NAME)-build -e DEBIAN_FRONTEND=noninteractive hooklift/$(NAME)
	@echo "$(OK_COLOR)------> Exporting rootfs...$(NO_COLOR)"
	docker export $(NAME)-build > $(DIST)/hooklift-$(NAME).tar
	@echo "$(OK_COLOR)------> Compressing rootfs...$(NO_COLOR)"
	gzip -c $(DIST)/hooklift-$(NAME).tar > $(DIST)/$(PACKAGE)
	rm -rf $(DIST)/hooklift-$(NAME).tar
	docker stop $(NAME)-build
	docker rm $(NAME)-build
	@#docker rmi hooklift/$(NAME)



