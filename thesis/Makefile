
# files to be compiled to generate sample PDFs
TEX_COMPILE=abst.tex cover1.tex cover2.tex guide.tex spine.tex

# files to be converted for each encoding (the original files are (supposed to be) in SJIS)
FILES_CONVERT=${TEX_COMPILE} AIabst.cls AIcover.cls AIthesis.sty personal.sty personal.tex

# files to be included in each archive file
FILES=Bschedule.pdf Mschedule.pdf README.txt ${FILES_CONVERT}

# directory/archive names for each encoding
dirSJIS=thesisSJIS
dirEUC=thesisEUC
dirUTF8=thesisUTF8

# tex commands for compilation
LATEXSJIS=platex -kanji=sjis
LATEXEUC=platex -kanji=euc
LATEXUTF8=platex -kanji=utf8
DVIPDFMX=dvipdfmx

# by default, builds all archive files
all: thesisSJIS.tar.gz thesisEUC.tar.gz thesisUTF8.tar.gz

thesisSJIS.tar.gz: ${FILES}
	rm -rf ${dirSJIS}
	mkdir ${dirSJIS}
	cp $^ ${dirSJIS}/
	cd ${dirSJIS} && for i in ${FILES_CONVERT}; do mv $$i $$i.bak; cat $$i.bak | nkf -s > $$i; done
	cd ${dirSJIS} && for i in ${TEX_COMPILE}; do ${LATEXSJIS} $$i; ${LATEXSJIS} $$i; ${DVIPDFMX} $${i%%.tex}; done
	cd ${dirSJIS} && rm -rf *.log *.aux *.dvi *.bak
	tar cvzf ${dirSJIS}.tar.gz ${dirSJIS}

thesisEUC.tar.gz: ${FILES}
	rm -rf ${dirEUC}
	mkdir ${dirEUC}
	cp $^ ${dirEUC}/
	cd ${dirEUC} && for i in ${FILES_CONVERT}; do mv $$i $$i.bak; cat $$i.bak | nkf -e > $$i; done
	cd ${dirEUC} && for i in ${TEX_COMPILE}; do ${LATEXEUC} $$i; ${LATEXEUC} $$i; ${DVIPDFMX} $${i%%.tex}; done
	cd ${dirEUC} && rm -rf *.log *.aux *.dvi *.bak
	tar cvzf ${dirEUC}.tar.gz ${dirEUC}

thesisUTF8.tar.gz: ${FILES}
	rm -rf ${dirUTF8}
	mkdir ${dirUTF8}
	cp $^ ${dirUTF8}/
	cd ${dirUTF8} && for i in ${FILES_CONVERT}; do mv $$i $$i.bak; cat $$i.bak | nkf -w > $$i; done
	cd ${dirUTF8} && for i in ${TEX_COMPILE}; do ${LATEXUTF8} $$i; ${LATEXUTF8} $$i; ${DVIPDFMX} $${i%%.tex}; done
	cd ${dirUTF8} && rm -rf *.log *.aux *.dvi *.bak
	tar cvzf ${dirUTF8}.tar.gz ${dirUTF8}


