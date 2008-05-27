# auto generated - do not edit

default: all

all:\
UNIT_TESTS/test.ali UNIT_TESTS/test.o UNIT_TESTS/test0001 \
UNIT_TESTS/test0001.ali UNIT_TESTS/test0001.o UNIT_TESTS/test0002 \
UNIT_TESTS/test0002.ali UNIT_TESTS/test0002.o UNIT_TESTS/test0003 \
UNIT_TESTS/test0003.ali UNIT_TESTS/test0003.o UNIT_TESTS/test0004 \
UNIT_TESTS/test0004.ali UNIT_TESTS/test0004.o UNIT_TESTS/test0005 \
UNIT_TESTS/test0005.ali UNIT_TESTS/test0005.o UNIT_TESTS/test0006 \
UNIT_TESTS/test0006.ali UNIT_TESTS/test0006.o UNIT_TESTS/test0007 \
UNIT_TESTS/test0007.ali UNIT_TESTS/test0007.o lua-load.a lua-load.ali \
lua-load.o

# Mkf-test
tests:
	(cd UNIT_TESTS && make tests)
tests_clean:
	(cd UNIT_TESTS && make clean)

# -- SYSDEPS start
flags-lua-ada:
	@echo SYSDEPS lua-ada-flags run create flags-lua-ada 
	@(cd SYSDEPS/modules/lua-ada-flags && ./run)
libs-lua-ada:
	@echo SYSDEPS lua-ada-libs run create libs-lua-ada 
	@(cd SYSDEPS/modules/lua-ada-libs && ./run)
libs-lua-S:
	@echo SYSDEPS lua-libs-S run create libs-lua-S 
	@(cd SYSDEPS/modules/lua-libs-S && ./run)


lua-ada-flags_clean:
	@echo SYSDEPS lua-ada-flags clean flags-lua-ada 
	@(cd SYSDEPS/modules/lua-ada-flags && ./clean)
lua-ada-libs_clean:
	@echo SYSDEPS lua-ada-libs clean libs-lua-ada 
	@(cd SYSDEPS/modules/lua-ada-libs && ./clean)
lua-libs-S_clean:
	@echo SYSDEPS lua-libs-S clean libs-lua-S 
	@(cd SYSDEPS/modules/lua-libs-S && ./clean)


sysdeps_clean:\
lua-ada-flags_clean \
lua-ada-libs_clean \
lua-libs-S_clean \


# -- SYSDEPS end


UNIT_TESTS/test.ads:\
lua-load.ads

UNIT_TESTS/test.ali:\
ada-compile UNIT_TESTS/test.adb UNIT_TESTS/test.ads
	./ada-compile UNIT_TESTS/test.adb

UNIT_TESTS/test.o:\
UNIT_TESTS/test.ali

UNIT_TESTS/test0001:\
ada-bind ada-link UNIT_TESTS/test0001.ald UNIT_TESTS/test0001.ali \
UNIT_TESTS/test.ali lua-load.ali
	./ada-bind UNIT_TESTS/test0001.ali
	./ada-link UNIT_TESTS/test0001 UNIT_TESTS/test0001.ali

UNIT_TESTS/test0001.ali:\
ada-compile UNIT_TESTS/test0001.adb UNIT_TESTS/test.ads
	./ada-compile UNIT_TESTS/test0001.adb

UNIT_TESTS/test0001.o:\
UNIT_TESTS/test0001.ali

UNIT_TESTS/test0002:\
ada-bind ada-link UNIT_TESTS/test0002.ald UNIT_TESTS/test0002.ali \
UNIT_TESTS/test.ali lua-load.ali
	./ada-bind UNIT_TESTS/test0002.ali
	./ada-link UNIT_TESTS/test0002 UNIT_TESTS/test0002.ali

UNIT_TESTS/test0002.ali:\
ada-compile UNIT_TESTS/test0002.adb UNIT_TESTS/test.ads
	./ada-compile UNIT_TESTS/test0002.adb

UNIT_TESTS/test0002.o:\
UNIT_TESTS/test0002.ali

UNIT_TESTS/test0003:\
ada-bind ada-link UNIT_TESTS/test0003.ald UNIT_TESTS/test0003.ali \
UNIT_TESTS/test.ali lua-load.ali
	./ada-bind UNIT_TESTS/test0003.ali
	./ada-link UNIT_TESTS/test0003 UNIT_TESTS/test0003.ali

UNIT_TESTS/test0003.ali:\
ada-compile UNIT_TESTS/test0003.adb UNIT_TESTS/test.ads
	./ada-compile UNIT_TESTS/test0003.adb

UNIT_TESTS/test0003.o:\
UNIT_TESTS/test0003.ali

UNIT_TESTS/test0004:\
ada-bind ada-link UNIT_TESTS/test0004.ald UNIT_TESTS/test0004.ali \
UNIT_TESTS/test.ali lua-load.ali
	./ada-bind UNIT_TESTS/test0004.ali
	./ada-link UNIT_TESTS/test0004 UNIT_TESTS/test0004.ali

UNIT_TESTS/test0004.ali:\
ada-compile UNIT_TESTS/test0004.adb UNIT_TESTS/test.ads
	./ada-compile UNIT_TESTS/test0004.adb

UNIT_TESTS/test0004.o:\
UNIT_TESTS/test0004.ali

UNIT_TESTS/test0005:\
ada-bind ada-link UNIT_TESTS/test0005.ald UNIT_TESTS/test0005.ali \
UNIT_TESTS/test.ali lua-load.ali
	./ada-bind UNIT_TESTS/test0005.ali
	./ada-link UNIT_TESTS/test0005 UNIT_TESTS/test0005.ali

UNIT_TESTS/test0005.ali:\
ada-compile UNIT_TESTS/test0005.adb UNIT_TESTS/test.ads
	./ada-compile UNIT_TESTS/test0005.adb

UNIT_TESTS/test0005.o:\
UNIT_TESTS/test0005.ali

UNIT_TESTS/test0006:\
ada-bind ada-link UNIT_TESTS/test0006.ald UNIT_TESTS/test0006.ali \
UNIT_TESTS/test.ali lua-load.ali
	./ada-bind UNIT_TESTS/test0006.ali
	./ada-link UNIT_TESTS/test0006 UNIT_TESTS/test0006.ali

UNIT_TESTS/test0006.ali:\
ada-compile UNIT_TESTS/test0006.adb UNIT_TESTS/test.ads
	./ada-compile UNIT_TESTS/test0006.adb

UNIT_TESTS/test0006.o:\
UNIT_TESTS/test0006.ali

UNIT_TESTS/test0007:\
ada-bind ada-link UNIT_TESTS/test0007.ald UNIT_TESTS/test0007.ali \
UNIT_TESTS/test.ali lua-load.ali
	./ada-bind UNIT_TESTS/test0007.ali
	./ada-link UNIT_TESTS/test0007 UNIT_TESTS/test0007.ali

UNIT_TESTS/test0007.ali:\
ada-compile UNIT_TESTS/test0007.adb UNIT_TESTS/test.ads
	./ada-compile UNIT_TESTS/test0007.adb

UNIT_TESTS/test0007.o:\
UNIT_TESTS/test0007.ali

ada-bind:\
conf-adabind conf-systype conf-adatype conf-adafflist flags-lua-ada flags-cwd

ada-compile:\
conf-adacomp conf-adatype conf-systype conf-adacflags conf-adafflist \
	flags-lua-ada flags-cwd

ada-link:\
conf-adalink conf-adatype conf-systype conf-aldfflist libs-lua-ada libs-cwd \
	libs-lua-S libs-math

ada-srcmap:\
conf-adacomp conf-adatype conf-systype

ada-srcmap-all:\
ada-srcmap conf-adacomp conf-adatype conf-systype

cc-compile:\
conf-cc conf-cctype conf-systype

cc-link:\
conf-ld conf-ldtype conf-systype

cc-slib:\
conf-systype

conf-adatype:\
mk-adatype
	./mk-adatype > conf-adatype.tmp && mv conf-adatype.tmp conf-adatype

conf-cctype:\
conf-cc mk-cctype
	./mk-cctype > conf-cctype.tmp && mv conf-cctype.tmp conf-cctype

conf-ldtype:\
conf-ld mk-ldtype
	./mk-ldtype > conf-ldtype.tmp && mv conf-ldtype.tmp conf-ldtype

conf-systype:\
mk-systype
	./mk-systype > conf-systype.tmp && mv conf-systype.tmp conf-systype

lua-load.a:\
cc-slib lua-load.sld lua-load.o
	./cc-slib lua-load lua-load.o

lua-load.ali:\
ada-compile lua-load.adb lua-load.ads
	./ada-compile lua-load.adb

lua-load.o:\
lua-load.ali

mk-adatype:\
conf-adacomp conf-systype

mk-cctype:\
conf-cc conf-systype

mk-ctxt:\
mk-mk-ctxt
	./mk-mk-ctxt

mk-ldtype:\
conf-ld conf-systype conf-cctype

mk-mk-ctxt:\
conf-cc

mk-systype:\
conf-cc

clean-all: sysdeps_clean tests_clean obj_clean ext_clean
clean: obj_clean
obj_clean:
	rm -f UNIT_TESTS/test.ali UNIT_TESTS/test.o UNIT_TESTS/test0001 \
	UNIT_TESTS/test0001.ali UNIT_TESTS/test0001.o UNIT_TESTS/test0002 \
	UNIT_TESTS/test0002.ali UNIT_TESTS/test0002.o UNIT_TESTS/test0003 \
	UNIT_TESTS/test0003.ali UNIT_TESTS/test0003.o UNIT_TESTS/test0004 \
	UNIT_TESTS/test0004.ali UNIT_TESTS/test0004.o UNIT_TESTS/test0005 \
	UNIT_TESTS/test0005.ali UNIT_TESTS/test0005.o UNIT_TESTS/test0006 \
	UNIT_TESTS/test0006.ali UNIT_TESTS/test0006.o UNIT_TESTS/test0007 \
	UNIT_TESTS/test0007.ali UNIT_TESTS/test0007.o lua-load.a lua-load.ali \
	lua-load.o
ext_clean:
	rm -f conf-adatype conf-cctype conf-ldtype conf-systype mk-ctxt

regen:\
ada-srcmap ada-srcmap-all
	./ada-srcmap-all
	cpj-genmk > Makefile.tmp && mv Makefile.tmp Makefile
