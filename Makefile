SHELL=/bin/bash
NAME=s3auth-nginx
HOSTNAME=auth.content.fasten.com
TAG=fasten.com/$(NAME)
all: build

build:
	@docker build -t $(TAG) --rm .
test: build
	@docker run --name $(NAME) --hostname $(HOSTNAME) -it --rm $(TAG)
start up run:
	@docker run --name $(NAME) --hostname $(HOSTNAME) -d $(TAG)
stop down shutdown:
	@docker stop $(NAME)
clean: stop
	@docker rm $(NAME)
logs:
	@docker logs $(NAME)
debug:
	@docker exec -it -u root $(NAME) $(SHELL)

