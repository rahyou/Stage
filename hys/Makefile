DIR=$(notdir $(CURDIR))
KERNEL_DIR = ./kernels
PACKAGES=spoc,camlimages
KERNELSSRC = $(KERNEL_DIR)/*.cl
NVCC = nvcc 
NVCCCFLAGS = -m64 -O3 -g -ptx 
SYNTAX_PACKAGES=spoc_external_kernels,sarek_syntax

CAMLC=ocamlfind ocamlc
MLSRC=$(DIR).ml
ASM=$(MLSRC:.ml=.asm)
BYTE=$(MLSRC:.ml=.byte)


NVCC_PRESENT := $(shell nvcc --version 1>/dev/null 2>/dev/null;  echo $$?)
ifeq ($(NVCC_PRESENT), 0)
        KERNELS = $(KERNELSSRC:.cu=.ptx)
endif


all :  $(BYTE)

$(BYTE) : $(MLSRC)
	$(CAMLC) -thread -package $(PACKAGES) -linkpkg \
	-package $(SYNTAX_PACKAGES) -syntax camlp4o -o $@ $<

%ptx: %cl
	$(NVCC) $(NVCCCFLAGS) $(NVCC_INCLUDES) -o $@ $<

%.o : %.c
	$(CC) -c $< -I `ocamlfind ocamlc -where`

clean:
	rm -rf *.o *.cm* *.a *.cmxa *~ *.exe *.nat *.byte *.obj *.asm kernels/*.ptx

