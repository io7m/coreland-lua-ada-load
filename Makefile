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
UNIT_TESTS/test0007.ali UNIT_TESTS/test0007.o ctxt/bindir.o ctxt/ctxt.a \
ctxt/dlibdir.o ctxt/incdir.o ctxt/repos.o ctxt/slibdir.o ctxt/version.o \
deinstaller deinstaller.o inst-check inst-check.o inst-copy inst-copy.o \
inst-dir inst-dir.o inst-link inst-link.o install_core.o install_error.o \
installer installer.o instchk instchk.o insthier.o lua-load-conf \
lua-load-conf.o lua-load.a lua-load.ali lua-load.o

# Mkf-deinstall
deinstall: deinstaller inst-check inst-copy inst-dir inst-link
	./deinstaller
deinstall-dryrun: deinstaller inst-check inst-copy inst-dir inst-link
	./deinstaller dryrun

# Mkf-install
install: installer inst-check inst-copy inst-dir inst-link postinstall
	./installer
	./postinstall

install-dryrun: installer inst-check inst-copy inst-dir inst-link
	./installer dryrun

# Mkf-instchk
install-check: instchk inst-check
	./instchk

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
conf-cc conf-cc mk-cctype
	./mk-cctype > conf-cctype.tmp && mv conf-cctype.tmp conf-cctype

conf-ldtype:\
conf-ld conf-ld mk-ldtype
	./mk-ldtype > conf-ldtype.tmp && mv conf-ldtype.tmp conf-ldtype

conf-systype:\
mk-systype
	./mk-systype > conf-systype.tmp && mv conf-systype.tmp conf-systype

# ctxt/bindir.c.mff
ctxt/bindir.c: mk-ctxt conf-bindir
	rm -f ctxt/bindir.c
	./mk-ctxt ctxt_bindir < conf-bindir > ctxt/bindir.c

ctxt/bindir.o:\
cc-compile ctxt/bindir.c
	./cc-compile ctxt/bindir.c

ctxt/ctxt.a:\
cc-slib ctxt/ctxt.sld ctxt/bindir.o ctxt/dlibdir.o ctxt/incdir.o ctxt/repos.o \
ctxt/slibdir.o ctxt/version.o
	./cc-slib ctxt/ctxt ctxt/bindir.o ctxt/dlibdir.o ctxt/incdir.o ctxt/repos.o \
	ctxt/slibdir.o ctxt/version.o

# ctxt/dlibdir.c.mff
ctxt/dlibdir.c: mk-ctxt conf-dlibdir
	rm -f ctxt/dlibdir.c
	./mk-ctxt ctxt_dlibdir < conf-dlibdir > ctxt/dlibdir.c

ctxt/dlibdir.o:\
cc-compile ctxt/dlibdir.c
	./cc-compile ctxt/dlibdir.c

# ctxt/incdir.c.mff
ctxt/incdir.c: mk-ctxt conf-incdir
	rm -f ctxt/incdir.c
	./mk-ctxt ctxt_incdir < conf-incdir > ctxt/incdir.c

ctxt/incdir.o:\
cc-compile ctxt/incdir.c
	./cc-compile ctxt/incdir.c

# ctxt/repos.c.mff
ctxt/repos.c: mk-ctxt conf-repos
	rm -f ctxt/repos.c
	./mk-ctxt ctxt_repos < conf-repos > ctxt/repos.c

ctxt/repos.o:\
cc-compile ctxt/repos.c
	./cc-compile ctxt/repos.c

# ctxt/slibdir.c.mff
ctxt/slibdir.c: mk-ctxt conf-slibdir
	rm -f ctxt/slibdir.c
	./mk-ctxt ctxt_slibdir < conf-slibdir > ctxt/slibdir.c

ctxt/slibdir.o:\
cc-compile ctxt/slibdir.c
	./cc-compile ctxt/slibdir.c

# ctxt/version.c.mff
ctxt/version.c: mk-ctxt VERSION
	rm -f ctxt/version.c
	./mk-ctxt ctxt_version < VERSION > ctxt/version.c

ctxt/version.o:\
cc-compile ctxt/version.c
	./cc-compile ctxt/version.c

deinstaller:\
cc-link deinstaller.ld deinstaller.o insthier.o install_core.o install_error.o \
ctxt/ctxt.a
	./cc-link deinstaller deinstaller.o insthier.o install_core.o install_error.o \
	ctxt/ctxt.a

deinstaller.o:\
cc-compile deinstaller.c install.h
	./cc-compile deinstaller.c

inst-check:\
cc-link inst-check.ld inst-check.o install_error.o
	./cc-link inst-check inst-check.o install_error.o

inst-check.o:\
cc-compile inst-check.c install.h
	./cc-compile inst-check.c

inst-copy:\
cc-link inst-copy.ld inst-copy.o install_error.o
	./cc-link inst-copy inst-copy.o install_error.o

inst-copy.o:\
cc-compile inst-copy.c install.h
	./cc-compile inst-copy.c

inst-dir:\
cc-link inst-dir.ld inst-dir.o install_error.o
	./cc-link inst-dir inst-dir.o install_error.o

inst-dir.o:\
cc-compile inst-dir.c install.h
	./cc-compile inst-dir.c

inst-link:\
cc-link inst-link.ld inst-link.o install_error.o
	./cc-link inst-link inst-link.o install_error.o

inst-link.o:\
cc-compile inst-link.c install.h
	./cc-compile inst-link.c

install_core.o:\
cc-compile install_core.c install.h
	./cc-compile install_core.c

install_error.o:\
cc-compile install_error.c install.h
	./cc-compile install_error.c

installer:\
cc-link installer.ld installer.o insthier.o install_core.o install_error.o \
ctxt/ctxt.a
	./cc-link installer installer.o insthier.o install_core.o install_error.o \
	ctxt/ctxt.a

installer.o:\
cc-compile installer.c install.h
	./cc-compile installer.c

instchk:\
cc-link instchk.ld instchk.o insthier.o install_core.o install_error.o \
ctxt/ctxt.a
	./cc-link instchk instchk.o insthier.o install_core.o install_error.o \
	ctxt/ctxt.a

instchk.o:\
cc-compile instchk.c install.h
	./cc-compile instchk.c

insthier.o:\
cc-compile insthier.c ctxt.h install.h
	./cc-compile insthier.c

lua-load-conf:\
cc-link lua-load-conf.ld lua-load-conf.o ctxt/ctxt.a
	./cc-link lua-load-conf lua-load-conf.o ctxt/ctxt.a

lua-load-conf.o:\
cc-compile lua-load-conf.c ctxt.h
	./cc-compile lua-load-conf.c

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
	UNIT_TESTS/test0007.ali UNIT_TESTS/test0007.o ctxt/bindir.c ctxt/bindir.o \
	ctxt/ctxt.a ctxt/dlibdir.c ctxt/dlibdir.o ctxt/incdir.c ctxt/incdir.o \
	ctxt/repos.c ctxt/repos.o ctxt/slibdir.c ctxt/slibdir.o ctxt/version.c \
	ctxt/version.o deinstaller deinstaller.o inst-check inst-check.o inst-copy \
	inst-copy.o inst-dir inst-dir.o inst-link inst-link.o install_core.o \
	install_error.o installer installer.o instchk instchk.o insthier.o \
	lua-load-conf lua-load-conf.o lua-load.a lua-load.ali lua-load.o
ext_clean:
	rm -f conf-adatype conf-cctype conf-ldtype conf-systype mk-ctxt

regen:\
ada-srcmap ada-srcmap-all
	./ada-srcmap-all
	cpj-genmk > Makefile.tmp && mv Makefile.tmp Makefile
