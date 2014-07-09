PROGRAMS += twdump
PROGRAMS += twdump-sort
PROGRAMS += twdump-list

all: lint

lint:
	pep8 $(PROGRAMS)
