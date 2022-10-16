#
# Linux Makefile for q2tools
#


# BUILD = RELEASE or DEBUG
BUILD ?= RELEASE

# Where programs will be installed on 'make install'
INSTALL_DIR ?= ./install

# Compiler
CC ?= gcc

# Compile Options
WITH_PTHREAD ?= -pthread -DUSE_PTHREADS
WITHOUT_PTHREAD ?= -DUSE_SETRLIMIT
# THREADING_OPTION = WITH_PTHREAD or WITHOUT_PTHREAD
THREADING_OPTION ?= $(WITH_PTHREAD)
BASE_CFLAGS ?= -fno-common -Wall -Wno-unused-result -Wno-strict-aliasing $(THREADING_OPTION) -DUSE_ZLIB -Wl,-z,stack-size=16777216
RELEASE_CFLAGS ?= $(BASE_CFLAGS) -O3 
DEBUG_CFLAGS ?= $(BASE_CFLAGS) -O0 -g -ggdb

# Link Options
LDFLAGS ?= -lm -lz

srcdir = .
includedirs = -Isrc

# source locations
vpath %.h src
vpath %.c src

ifeq ($(BUILD),DEBUG)
CFLAGS ?= $(DEBUG_CFLAGS)
builddir = debug
vpath %.o debug
else
CFLAGS ?= $(RELEASE_CFLAGS)
builddir = release
vpath %.o release
endif


srcs = \
	bspfile.c	\
	cmdlib.c	\
	l3dslib.c	\
	llwolib.o	\
	lbmlib.c	\
	mathlib.c	\
	mdfour.c	\
	polylib.c	\
	scriplib.c	\
	trilib.c	\
	threads.c	\
	images.c	\
	models.c	\
	data.c		\
	sprites.c	\
	tables.c	\
	video.c		\
	main.c		\
	rad.c		\
	lightmap.c	\
	patches.c 	\
	trace.c		\
	bsp.c 	    \
	brushbsp.c	\
	faces.c		\
	leakfile.c	\
	map.c		\
	portals.c	\
	prtfile.c	\
	textures.c	\
	tree.c		\
	writebsp.c	\
	csg.c		\
	vis.c 		\
	flow.c 

objs = $(srcs:.c=.o)



all: subdirectories $(builddir)/q2tool

# link
$(builddir)/q2tool: $(objs)
	$(CC) $(CFLAGS) $(addprefix $(builddir)/, $(objs)) -o $(builddir)/q2tool $(LDFLAGS)

# compile sources
$(objs): %o : %c
	$(CC) -c $(includedirs) $(CFLAGS) $< -o $(builddir)/$@

subdirectories:
	mkdir -p $(builddir)

clean:
	rm -f $(builddir)/*.o
	rm -f $(builddir)/q2tool\

# Add to remove executables from install directory

#	rm -f $(INSTALL_DIR)/q2tool

install:
	mkdir -p $(INSTALL_DIR)
	cp $(builddir)/q2tool $(INSTALL_DIR)
