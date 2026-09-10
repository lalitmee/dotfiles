CC ?= gcc
CFLAGS ?= -O2 -Wall -Wextra
LDFLAGS ?= -lX11 -lXi -lXrandr
PREFIX ?= $(HOME)/.local
BINDIR ?= $(PREFIX)/bin
TARGET = mouse_funnel

all: $(TARGET)

$(TARGET): mouse_funnel.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

install: $(TARGET)
	mkdir -p $(DESTDIR)$(BINDIR)
	install -m 755 $(TARGET) $(DESTDIR)$(BINDIR)/$(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all install clean
