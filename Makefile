# You may override this variable from the command line. E.g.:
# make target=foo
# make clean target=foo
target = main

ifeq ($(OS),Windows_NT)
	# Not using Acrobat, it locks the file from further compilation.
	# https://community.adobe.com/t5/acrobat-reader/disable-file-lock-on-adobe-reader-dc-windows-10/td-p/9164368
	PDF_READER=chrome
else ifeq ($(shell uname), Linux)
	PDF_READER=xdg-open
else
	# If this doesn't work, you Mac users figure them out yourselves :P
	PDF_READER=open
endif

.PHONY : clean all

all : clean $(patsubst %,%.pdf,$(target)) open

clean :
	for i in aux log bbl blg bcf out run.xml pdf; do \
		rm -f $(patsubst %,%.$$i,$(target)); \
	done
	-rm -f *~

# You may append other dependencies
%.pdf : %.tex 
	$(eval basename = $(patsubst %.tex,%,$<))
	pdflatex $(basename)
	pdflatex $(basename)

open:
	$(PDF_READER) $(shell pwd)/$(target).pdf &