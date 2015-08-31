# Top level makefile for CCCC

# This distribution is a compilation of code, some of which comes from
# different sources, some of which builds different (e.g. Win32 DLL) kinds
# of targets.
# I would like to make it less inconsistent, but the first stage is to make 
# it work...

DOX	= doxygen
CCCC	= ./cccc/cccc
CCCOPTS	= --lang=c++
CCCCSRC = ./cccc/*.cc ./cccc/*.h
GENSRC	= cccc/CLexer.cpp \
          cccc/CLexer.h \
          cccc/CParser.cpp \
          cccc/CParser.h \
          cccc/Ctokens.h \
          cccc/JLexer.cpp \
          cccc/JLexer.h \
          cccc/JParser.cpp \
          cccc/JParser.h \
          cccc/Jtokens.h \
          cccc/cccc.cpp \
          cccc/java.cpp \
          cccc/parser.dlg

.PHONY : all mini pccts cccc test

all : mini cccc test

mini :
	cd pccts && $(MAKE) -Orecurse antlr dlg || exit $$?

pccts :
	cd pccts && $(MAKE) -Orecurse $@ || exit $$?

cccc :	mini
	cd cccc && $(MAKE) -Orecurse -f posixgcc.mak $@ || exit $$?

.NOTPARALLEL:	test
test :
	cd test && $(MAKE) -Orecurse -f posix.mak || exit $$?

DOCS	= doxygen
METRICS	= ccccout

$(METRICS)/.keep_dir :
	mkdir -p $(dir $@)
	touch $@

metrics : $(METRICS)/.keep_dir
	rm -rf $(METRICS)/*.html
	$(CCCC) $(CCCOPTS) --outdir=$(METRICS)/ $(CCCCSRC)
	@echo "Metrics output now in $(METRICS)/cccc.html"

$(DOCS)/.keep_dir :
	mkdir -p $(dir $@)
	touch $@

docs :	Doxyfile.html_cfg $(CCCCSRC) $(DOCS)/.keep_dir
	rm -rf $(DOCS)/html
	$(DOX) Doxyfile.html_cfg
	@echo "API docs now in $(DOCS)/html"

clean	:
	rm -rf cccc/*.o cccc/cccc $(GENSRC) pccts/bin/*

reallyclean :
	rm -rf ccccout/* doxygen/html
