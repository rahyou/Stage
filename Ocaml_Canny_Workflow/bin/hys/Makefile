
PACKAGES=spoc,camlimages
SYNTAX_PACKAGES=spoc_external_kernels,sarek_syntax
CAMLC=ocamlfind ocamlc
MLSRC= $(wildcard *.ml)
CMO=$(MLSRC:.ml=.cmo)
ASM=$(MLSRC:.ml=.asm)
BYTE=hys.byte


all : depend $(BYTE)

$(BYTE) : $(CMO)
	@echo $^;
	$(CAMLC) -thread -package $(PACKAGES) -linkpkg \
	-package $(SYNTAX_PACKAGES) -syntax camlp4o -o $(BYTE) $^

%.cmo: %.ml
	$(CAMLC) -thread -package $(PACKAGES) -linkpkg \
	-package $(SYNTAX_PACKAGES) -syntax camlp4o -c $<

%.o : %.c
	$(CC) -c $< -I `ocamlfind ocamlc -where`

depend:
	ocamlfind ocamldep *.ml > .depend

include .depend

clean:
	rm -rf *.o *.cmo *.cmi *.a *.cmxa *~ *.exe *.nat *.byte *.obj *.asm kernels/*.ptx

