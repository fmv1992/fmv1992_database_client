export ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

export SHELL := /bin/bash -euo pipefail

ERL_FILES := $(sort $(shell find . -iname '*.erl' -o -iname '*.hrl' | grep --invert-match -E '_build'))

PROJECT := $(notdir $(ROOT_DIR))

all: format test

dev:
	cp ./other/git/hooks/* ./.git/hooks/

format:
	cd ./$(PROJECT) && make format

vim:
	vim $(ERL_FILES)
	stty sane

test:
	cd ./$(PROJECT)/ \
        && rebar3 help proper \
        && rebar3 proper \
        && rebar3 eunit

clean:
ifeq ($(PROJECT), fmv1992_erlang_project_template)
	comm -2 -3 \
        <(find . -type f | grep --invert-match --extended-regexp '/\.git/' | sort -u) \
        <(git ls-tree --full-tree --name-only -r HEAD | sort -u | sed --regexp-extended 's#^#./#g') \
            | xargs --no-run-if-empty -n 100 -- rm
endif
	find . -type d | grep --invert-match --extended-regexp '/\.git/' | xargs --no-run-if-empty -n 1 -- rmdir --parents 2>/dev/null || true
	find . -iname '_build' -type d | grep --invert-match --extended-regexp '/\.git/' | xargs --no-run-if-empty -n 1 -- rm -rf
