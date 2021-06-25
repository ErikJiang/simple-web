PROJECTNAME=$(shell basename "$(PWD)")
EXT_TAG ?=
PROJECTNAME=simple-web
GIT_BRANCH=`git rev-parse --abbrev-ref HEAD`
REGISTRY_ENDPOINT=registry.cn-hangzhou.aliyuncs.com/wise2c-dev
IMAGENAME=$(REGISTRY_ENDPOINT)/$(PROJECTNAME):$(GIT_BRANCH)${EXT_TAG}

all: help

.PHONY: help run image

## image		build docker image.
image:
	@docker load --input build/python.2.7.alpine.tar.bz2	
	@docker build -f Dockerfile -t $(IMAGENAME) ./
	@docker push $(IMAGENAME)

## start		start docker continer.
start:
	@docker run -d -p 8001:80 --name $(PROJECTNAME) $(IMAGENAME)

## stop		stop docker continer.
stop:
	@docker stop $(PROJECTNAME)
	@docker rm $(PROJECTNAME)

## help		print this help message and exit.
help: Makefile
	@echo "Choose a command run in "$(PROJECTNAME)":"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Valid target values are:"
	@echo ""
	@sed -n 's/^## //p' $<
