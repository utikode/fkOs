# Makefile (host orchestration; heavy build runs in WSL)
.PHONY: all kernel iso

all: kernel iso

kernel:
	bash build/build-kernel.sh

iso:
	bash build/build-iso.sh
