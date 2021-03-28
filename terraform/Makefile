PWD                      := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SHELL                    := /usr/bin/env bash

#
.PHONY: init
# Initialize project.
init:
	if openssl genrsa -out private_key.pem 2048
	if ssh-keygen -y -f private_key.pem > public_key.pub
