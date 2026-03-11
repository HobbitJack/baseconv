.POSIX:	
.PHONY:	all clean install release source uninstall
.SUFFIXES:

PREFIX 	?= /usr/local

all:	baseconv

baseconv:	baseconv.c baseconv.g.c baseconv.g.h baseconv.l.c baseconv.l.h
	c99 -lgmp -o $@ baseconv.c baseconv.g.c baseconv.l.c

baseconv.l.c baseconv.l.h:	baseconv.l
	lex -D_POSIX_C_SOURCE=200809L -o baseconv.l.c baseconv.l

baseconv.g.c baseconv.g.h:	baseconv.g
	gengetopt <baseconv.g
	sed -E 's/(\\n)?[[:blank:]]+\(default=.*\)//' <baseconv.g.c >baseconv.g.c.tmp
	mv -f baseconv.g.c.tmp baseconv.g.c

clean:
	rm -f baseconv baseconv.g.? baseconv.l.? baseconv*.tar.gz baseconv.1.gz Makefile

source:
	rm -f baseconv_source.tar.gz
	tar -cf baseconv_source.tar baseconv.c baseconv.g baseconv.l baseconv.1 makefile
	gzip baseconv_source.tar

release:	baseconv
	rm -f baseconv.tar.gz
	sed 6,33d makefile | sed '2c .PHONY:	install uninstall'> Makefile
	tar -cf baseconv.tar baseconv baseconv.c baseconv.g baseconv.l baseconv.1 Makefile
	gzip baseconv.tar

install:	baseconv
	mkdir -p $(PREFIX)/bin/
	install baseconv $(PREFIX)/bin/
	gzip -k baseconv.1
	mkdir -p $(PREFIX)/share/man/man1/
	install baseconv.1.gz $(PREFIX)/share/man/man1/

uninstall:
	rm $(PREFIX)/bin/baseconv
	rm $(PREFIX)/share/man/man1/baseconv.1.gz 
