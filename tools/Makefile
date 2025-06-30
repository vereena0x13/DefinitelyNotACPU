EXE=cputool
SRC_DIR=src

CC=g++
STD=c++20

WARNINGS=-Wsuggest-override -Wno-switch -Wno-parentheses -Wvolatile -Wextra-semi -Wimplicit-fallthrough -Wsequence-point
INCLUDES=-I../vendor/vstd -I../cpu_ctrl

CXXFLAGS=--std=$(STD) $(INCLUDES) -ftabstop=4 -fmax-errors=15 $(WARNINGS) -mavx -mavx2 -maes -nostdinc++ -fno-exceptions -fconcepts-diagnostics-depth=5
LDFLAGS=-lm -lpthread

.PHONY: all debug release clean

all: debug

debug: clean
debug: CXXFLAGS+=-O0
debug: CXXFLAGS+=-g
debug: CXXFLAGS+=-DBG_DEBUG
debug: $(EXE)

release: clean
release: CXXFLAGS+=-O2
release: CXXFLAGS+=-DBG_RELEASE
release: $(EXE)

clean:
	rm -f $(EXE)

$(EXE):
	$(CC) $(CXXFLAGS) -o $(EXE) src/main.cpp $(LDFLAGS)