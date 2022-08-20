SHELL := /bin/bash

# `erlang` related stuff. --- {{{

# ???: Rebar3 has to set this crazyness:
# <https://github.com/erlang/rebar3/issues/2669>.
REBAR_GLOBAL_CONFIG_DIR :=
REBAR_CONFIG :=

# `erlang`-`make` specific rules. --- {{{

SOURCE_DIR := src

TARGET_DIR := ebin

SOURCES = $(wildcard $(SOURCE_DIR)/*.erl)

# Define objects for all sources
TARGETS := $(subst $(SOURCE_DIR),$(TARGET_DIR),$(SOURCES:.erl=.beam))

# Add this list to VPATH, the place make will look for the source files
# VPATH = src
vpath %.erl $(SOURCE_DIR)

# --- }}}

# `erlang` configuration. --- {{{

ERLC_FLAGS := -v -I $(HOME)/bin/erlang -pz $(TARGET_DIR) -o $(TARGET_DIR)
ERL_LIBS := $(ERL_LIBS):$(HOME)/bin/erlang
DIALYZER_FLAGS := -I $(HOME)/bin/erlang

# ???: Find the `edoc` binary path... Erlang craziness...
EDOC_BINARY := $(shell printf '%s\n' $(wildcard /usr/lib/erlang/lib/edoc-*/bin/edoc) | one --n 1)

# --- }}}

# --- }}}

all: $(TARGETS) doc

format:
	rebar3 fmt --print-width 79 --write

ebin/%.beam: %.erl
	erlc $(ERLC_FLAGS) $<

# ???: How does one avoid this nonsense?
doc: ./doc/index.html

doc/index.html: $(SOURCES) ./doc/overview.edoc
	$(EDOC_BINARY) -files $(SOURCES) -I $(HOME)/bin/erlang -o doc

# ???: `dialyzer` is missing.DIALYZER_FLAGS
# See `fmv1992_erlang_id3_tags:077c43f:fmv1992_erlang_id3_tags/makefile:39` for
# details.

.PHONY: all

# vim: set noexpandtab foldmethod=marker fileformat=unix filetype=make nowrap foldtext=foldtext():
