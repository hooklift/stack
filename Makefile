NAME 		= rootfs
VERSION 	= 1.0.0
OK_COLOR 	= \x1b[32;01m
NO_COLOR    	= \x1b[0m

rootfs:
	@echo "$(OK_COLOR)------> Building Hooklift rootfs image...$(NO_COLOR)"
	docker build --force-rm=true -t hooklift/$(NAME) .
	@echo "$(OK_COLOR)------> Running image so that we can export it...$(NO_COLOR)"
	docker run --name $(NAME)-build -e DEBIAN_FRONTEND=noninteractive hooklift/$(NAME)
	@echo "$(OK_COLOR)------> Exporting rootfs...$(NO_COLOR)"
	docker export $(NAME)-build > hooklift-$(NAME).tar
	@echo "$(OK_COLOR)------> Compressing rootfs...$(NO_COLOR)"
	gzip -c hooklift-$(NAME).tar > hooklift-$(NAME)-v$(VERSION).tar.gz
	rm -rf hooklift-$(NAME).tar
	docker stop $(NAME)-build
	docker rm $(NAME)-build
	@#docker rmi hooklift/$(NAME)
	@echo "$(OK_COLOR)-----> Done$(NO_COLOR)"
