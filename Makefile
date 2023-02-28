CFLAGS=-Wall -g
PCFLAGS=-march=native -Ofast

BASECFLAGS=-march=native -Ofast -finline-functions -fopenmp
BASEIFLAGS=-xHost -Ofast -finline-functions -qopenmp -qopt-report -qopt-report-file=dist.icx.optrpt

GCCFLAGS=-march=native -Ofast -funroll-loops -finline-functions -fprefetch-loop-arrays -ftree-vectorize -ftree-loop-vectorize -ftree-loop-optimize -fopenmp -fopt-info-all=dist.gcc.optrpt
CCCFLAGS=-march=native -Ofast -funroll-loops -finline-functions -fopenmp -fsave-optimization-record
ICXFLAGS=-xHost -Ofast -unroll -finline-functions -qopenmp -qopt-report -qopt-report-file=dist.icx.optrpt
#ICXFLAGSPLUS=-xHost -Ofast -unroll -finline-functions -qopt-zmm-usage=high -qopenmp

all: mask_base mask

mask_base: mask_base.c
	gcc $(CFLAGS) $(BASECFLAGS) -fopt-info-all=dist.gcc.optrpt $< -o base_gcc
	clang $(CFLAGS) $(BASECFLAGS) -fsave-optimization-record $< -o base_clang
	icx $(CFLAGS) $(BASEIFLAGS) $< -o base_icx

mask: mask.c
	gcc $(CFLAGS) $(GCCFLAGS) $< -o mask_gcc 
	clang $(CFLAGS) $(CCCFLAGS) $< -o mask_clang
	icx $(CFLAGS) $(ICXFLAGS) $< -o mask_icx

genseq: genseq.c
	$(CC) $(PCFLAGS) $(CFLAGS) $< -o $@

clean:
	rm -Rf *~ genseq *_gcc *_clang *_icx *.optrpt *.yaml mask.dat
