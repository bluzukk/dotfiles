# st - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

SRC = st.c x.c boxdraw.c
OBJ = $(SRC:.c=.o)

all: options st

options:
	@echo st build options:
	@echo "CFLAGS  = $(STCFLAGS)"
	@echo "LDFLAGS = $(STLDFLAGS)"
	@echo "CC      = $(CC)"

config.h:
	cp config.def.h config.h

.c.o:
	$(CC) $(STCFLAGS) -c $<

st.o: config.h st.h win.h
x.o: arg.h config.h st.h win.h
boxdraw.o: config.h st.h boxdraw_data.h

$(OBJ): config.h config.mk

st: $(OBJ)
	$(CC) -o st $(OBJ) $(STLDFLAGS)

clean:
	rm -f st config.h $(OBJ) st-$(VERSION).tar.gz

dist: clean
	mkdir -p st-$(VERSION)
	cp -R FAQ LEGACY TODO LICENSE Makefile README config.mk\
		config.def.h st.info st.1 arg.h st.h win.h $(SRC)\
		st-$(VERSION)
	tar -cf - st-$(VERSION) | gzip > st-$(VERSION).tar.gz
	rm -rf st-$(VERSION)

install: st
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f st $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < st.1 > $(DESTDIR)$(MANPREFIX)/man1/st.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/st.1
	mkdir -p $(DESTDIR)$(PREFIX)/share/terminfo
	env TERMINFO=$(DESTDIR)$(PREFIX)/share/terminfo tic -sx st.info

.PHONY: all options clean dist install uninstall
