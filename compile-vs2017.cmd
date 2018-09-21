rem @echo off

REM ----------------------------------------------------------------------
REM PREREQUISITES:
REM * 7-zip (for packing the archives and SFXs).
REM * gettext (for the src/po folder).
REM * A local clone of the Vim repository (here: /vim). I take mine from
REM   Bitbucket: https://bitbucket.org/vim-mirror/vim/
REM * Visual Studio 2017 or higher (Community Edition would work) with
REM   the Windows Kit 8.1.
REM * Strawberry Perl, ActiveTcl (x86 and x64), Lua for Windows, Python2
REM   and Python3.
REM * Racket, compiled with the same MSVC version.
REM * Depending on your Perl distribution, you might have to fix Perl's
REM   config file (CORE/config.h) by commenting out symbols you don't have
REM   (like STDBOOL).
REM * Also you'll need to grab Ruby 2.x from the RubyInstaller:
REM   http://rubyinstaller.org/. You will have to generate your own
REM   config.h file for it to work though. Please refer to Vim's docs in
REM   src\INSTALLpc.txt (paragraph 11).
REM * TERMINAL support is compiled in with winpty. You'll need winpty-agent
REM   and winpty.dll in the appropriate binary directories. winpty can be
REM   obtained from https://github.com/rprichard/winpty/releases (use the
REM   MSVC version, just in case).
REM * diff.exe and patch.exe from the official Vim releases. (Can be left
REM   out if you wish.)
REM ----------------------------------------------------------------------

REM update the sources ...
REM ------------------------------------

IF NOT EXIST "vim" (
  call git clone https://github.com/vim/vim.git "vim"
)

:: @set ORIGINAL_DIR=%CD%
chdir /d "vim"
call git pull
call git submodule update --init --recursive
:: chdir /d "%ORIGINAL_DIR%"


REM set vars ...
REM ------------------------------------

REM LIBPYTHON2 = short (2-digit) version of Python 2.x
REM LIBPYTHON3 = short (2-digit) version of Python 3.x
REM LIBTCLSHRT = short (2-digit) version of Tcl
REM LIBTCLLONG = long (x.y) version of Tcl
REM LIBRBYSHRT = short (2-digit) version of Ruby
REM LIBRBYLONG = long (x.y.z) version of Ruby
REM LIBRBYLIB  = Ruby version (x.y.z) in the library folder name
REM LIBLUASHRT = short (2-digit) version of Lua
REM LIBLUALONG = long (x.y) version of Lua
REM LIBPERLVER = 3-digit version of Perl
REM LIBRACKET  = current version of your libracket.lib (part of its file name)

REM LUA_DIR     = Lua installation directory
REM PERL_DIR    = Perl installation directory
REM PYTHON2_DIR = Python 2 installation directory
REM PYTHON3_DIR = Python 3 installation directory
REM RACKET_DIR  = Racket installation directory
REM RUBY_DIR    = Ruby installation directory
REM TCL32DIR    = Tcl installation directory (x86)
REM TCL64DIR    = Tcl installation directory (x64)

REM PATCHDIFF = the directory where patch.exe and diff.exe reside
REM MSVCDIR   = the directory where Visual Studio resides, containing the /VC folder
REM WINPTYDIR = the root directory of your winpty folder (see the intro for details)

set LIBPYTHON2=27
set LIBPYTHON3=37
set LIBTCLSHRT=86
set LIBTCLLONG=8.6
set LIBRBYSHRT=25
set LIBRBYLONG=2.5.1
set LIBRBYLIB=2.5.0
set LIBLUASHRT=53
set LIBLUALONG=5.3
set LIBPERLVER=528
set LIBRACKET=7.0

set LUA_DIR=d:\operation\lua-5.3.4
set PERL_DIR=d:\operation\portablePerl\perl
set PYTHON2_DIR=C:\Python%LIBPYTHON2%
set PYTHON3_DIR=%USERPROFILE%\AppData\Local\Programs\Python\Python37
set RACKET_DIR=d:\operation\racket-7.0-x86_64
set RUBY_DIR=d:\operation\Ruby251-x64
set TCL32DIR=d:\operation\tcl-8.6.6.8607-MSWin32
set TCL64DIR=d:\operation\tcl-8.6.7.0

set PATCHDIFF=..\..\..\..\vim81
:: set MSVCDIR=%PROGRAMFILES(X86)%\Microsoft Visual Studio 14.0
set MSVCDIR=%PROGRAMFILES(X86)%\Microsoft Visual Studio\2017\Community
set WINPTYDIR=d:\operation\winpty-0.4.3-msvc2015
set GETTEXTDIR=d:\operation\gettext-0.19.8.1


REM -----------------------------------------------------
REM you probably won't have to edit anything below this.
REM -----------------------------------------------------


REM create output directory ...
REM ------------------------------------

if not exist src\tempoutput mkdir src\tempoutput
if not exist src\tempoutput mkdir src\tempoutput\x86
if not exist src\tempoutput mkdir src\tempoutput\x64


REM make clean (manually)
REM -------------------------------------

cd src
if exist del /Q ObjCULYHTRZAMD64\*.*
if exist del /Q ObjCULYHTRZi386\*.*
if exist del /Q ObjGXOULYHTRZAMD64\*.*
if exist del /Q ObjGXOULYHTRZi386\*.*
if exist del /Q ObjGXULYHTRZAMD64\*.*
if exist del /Q ObjGXULYHTRZi386\*.*


REM delete archive files
REM -------------------------------------

if exist del tempoutput\complete*.7z
if exist del tempoutput\complete*.exe

if /I "%1"=="" (
  set ARCH=x64
) else (
  set ARCH=%1
)

goto %ARCH%
echo Unknown build target.
exit 1

REM prepare the environment ...
REM ------------------------------------

:x86
if exist del gvim_noOLE.exe
:: call "%MSVCDIR%\VC\vcvarsall.bat" x86 8.1
call "%MSVCDIR%\VC\Auxiliary\Build\vcvars32.bat"


REM compile! (x86)
REM -------------------------------------

nmake /C /S /f Make_mvc.mak clean
nmake /C /S /f Make_mvc.mak ^
    CPU=i386  DEBUG=no USE_MSVCRT=yes FEATURES=HUGE CHANNEL=yes MBYTE=yes CSCOPE=yes TERMINAL=yes IME=yes GIME=yes GUI=yes OLE=no  XPM=.\xpm\x86 DIRECTX=yes ^
    PERL=%PERL_DIR% DYNAMIC_PERL=yes PERL_VER=%LIBPERLVER% ^
    LUA="%LUA_DIR%" DYNAMIC_LUA=yes LUA_VER=%LIBLUASHRT% ^
    TCL=%TCL32DIR% TCL_VER=%LIBTCLSHRT% TCL_VER_LONG=%LIBTCLLONG% DYNAMIC_TCL=yes ^
    RUBY=%RUBY_DIR% DYNAMIC_RUBY=yes RUBY_VER=%LIBRBYSHRT% RUBY_VER_LONG=%LIBRBYLIB% RUBY_PLATFORM=i386-mswin32_140 RUBY_MSVCRT_NAME=msvcrt ^
    PYTHON=%PYTHON2_DIR% DYNAMIC_PYTHON=yes PYTHON_VER=%LIBPYTHON2% ^
    PYTHON3=%PYTHON3_DIR% DYNAMIC_PYTHON3=yes PYTHON3_VER=%LIBPYTHON3% ^
    MZSCHEME="%RACKET_DIR%" DYNAMIC_MZSCHEME=yes MZSCHEME_MAIN_LIB=racket MZSCHEME_VER=%LIBRACKET%

:: ren gvim.exe gvim_noOLE.exe
:: 
:: nmake /C /S /f Make_mvc.mak clean
:: nmake /C /S /f Make_mvc.mak ^
::     CPU=i386  DEBUG=no USE_MSVCRT=yes FEATURES=HUGE CHANNEL=yes MBYTE=yes CSCOPE=yes TERMINAL=yes IME=yes GIME=yes GUI=yes OLE=yes XPM=.\xpm\x86 DIRECTX=yes ^
::     PERL=%PERL_DIR% DYNAMIC_PERL=yes PERL_VER=%LIBPERLVER% ^
::     LUA="%LUA_DIR%" DYNAMIC_LUA=yes LUA_VER=%LIBLUASHRT% ^
::     TCL=%TCL32DIR% TCL_VER=%LIBTCLSHRT% TCL_VER_LONG=%LIBTCLLONG% DYNAMIC_TCL=yes ^
::     RUBY=%RUBY_DIR% DYNAMIC_RUBY=yes RUBY_VER=%LIBRBYSHRT% RUBY_VER_LONG=%LIBRBYLIB% RUBY_PLATFORM=i386-mswin32_140 RUBY_MSVCRT_NAME=msvcrt ^
::     PYTHON=%PYTHON2_DIR% DYNAMIC_PYTHON=yes PYTHON_VER=%LIBPYTHON2% ^
::     PYTHON3=%PYTHON3_DIR% DYNAMIC_PYTHON3=yes PYTHON3_VER=%LIBPYTHON3% ^
::     MZSCHEME="%RACKET_DIR%" DYNAMIC_MZSCHEME=yes MZSCHEME_MAIN_LIB=racket MZSCHEME_VER=%LIBRACKET%

nmake /C /S /f Make_mvc.mak clean
nmake /C /S /f Make_mvc.mak ^
    CPU=i386  DEBUG=no USE_MSVCRT=yes FEATURES=HUGE CHANNEL=yes MBYTE=yes CSCOPE=yes TERMINAL=yes IME=no  GIME=no  GUI=no  OLE=no  XPM=.\xpm\x86 DIRECTX=no ^
    PERL=%PERL_DIR% DYNAMIC_PERL=yes PERL_VER=%LIBPERLVER% ^
    LUA="%LUA_DIR%" DYNAMIC_LUA=yes LUA_VER=%LIBLUASHRT% ^
    TCL=%TCL32DIR% TCL_VER=%LIBTCLSHRT% TCL_VER_LONG=%LIBTCLLONG% DYNAMIC_TCL=yes ^
    RUBY=%RUBY_DIR% DYNAMIC_RUBY=yes RUBY_VER=%LIBRBYSHRT% RUBY_VER_LONG=%LIBRBYLIB% RUBY_PLATFORM=i386-mswin32_140 RUBY_MSVCRT_NAME=msvcrt ^
    PYTHON=%PYTHON2_DIR% DYNAMIC_PYTHON=yes PYTHON_VER=%LIBPYTHON2% ^
    PYTHON3=%PYTHON3_DIR% DYNAMIC_PYTHON3=yes PYTHON3_VER=%LIBPYTHON3% ^
    MZSCHEME="%RACKET_DIR%" DYNAMIC_MZSCHEME=yes MZSCHEME_MAIN_LIB=racket MZSCHEME_VER=%LIBRACKET%


REM keep up the right directory structure
REM -------------------------------------

cd po
:: nmake -f Make_mvc.mak install-all
nmake -f Make_mvc.mak GETTEXT_PATH=d:\operation\gettext-0.14.4\bin install-all
cd ..

robocopy ..\runtime\ tempoutput\x86\ /MIR /NP /NJH /NJS /NFL /NDL
copy ..\vimtutor.* tempoutput\x86\
xcopy xxd\xxd.exe tempoutput\x86\ /K
xcopy tee\tee.exe tempoutput\x86\ /K
xcopy *.exe tempoutput\x86\ /K
:: copy vimtbar.dll tempoutput\x86\
copy README.txt tempoutput\x86\

if exist del gvim_noOLE.exe

if not exist tempoutput\x86\GVimExt32 mkdir tempoutput\x86\GVimExt32
if not exist tempoutput\x86\VisVim mkdir tempoutput\x86\VisVim

copy gvimext\*.dll tempoutput\x86\GVimExt32\
copy gvimext\*.inf tempoutput\x86\GVimExt32\
copy gvimext\*.reg tempoutput\x86\GVimExt32\
copy gvimext\README.txt tempoutput\x86\GVimExt32\
copy /Y %GETTEXTDIR%\bin\libiconv-2.dll tempoutput\x86\GVimExt32\
copy /Y %GETTEXTDIR%\bin\libintl-8.dll  tempoutput\x86\GVimExt32\
if exist %GETTEXTDIR%\bin\libgcc_s_sjlj-1.dll copy /Y %GETTEXTDIR%\libgcc_s_sjlj-1.dll tempoutput\x86\GVimExt32\


copy VisVim\*.txt tempoutput\x86\VisVim\
copy VisVim\*.dll tempoutput\x86\VisVim\
copy VisVim\*.bat tempoutput\x86\VisVim\

copy %WINPTYDIR%\ia32\bin\winpty.dll tempoutput\x86\winpty32.dll
copy %WINPTYDIR%\ia32\bin\winpty-agent.exe tempoutput\x86\

if exist %PATCHDIFF%\patch.exe copy %PATCHDIFF%\patch.exe tempoutput\x86\
if exist %PATCHDIFF%\diff.exe copy %PATCHDIFF%\diff.exe tempoutput\x86\


if exist %GETTEXTDIR%\bin\libgcc_s_sjlj-1.dll copy /Y %GETTEXTDIR%\libgcc_s_sjlj-1.dll tempoutput\x86\

copy /Y %GETTEXTDIR%\bin\libiconv-2.dll tempoutput\x86\
copy /Y %GETTEXTDIR%\bin\libintl-8.dll  tempoutput\x86\

REM cleanup
REM ------------------------------------

del tempoutput\x86\vimlogo.*
del tempoutput\x86\*.png
del tempoutput\x86\vim??x??.*


REM pack it!
REM ------------------------------------

cd tempoutput\x86
7z a -mx=9 -r -bd ..\complete-x86.7z *
7z a -mx=9 -r -bd -sfx7z.sfx ..\complete-x86.exe *
::cd ..\..
cd ..
cd ..
cd ..
cd ..

goto upload


:x64


REM prepare the environment ...
REM ------------------------------------

if exist del gvim_noOLE.exe
:: call "%MSVCDIR%\VC\vcvarsall.bat" amd64 8.1
call "%MSVCDIR%\VC\Auxiliary\Build\vcvars64.bat"


REM compile! (x64)
REM -------------------------------------

nmake /C /S /f Make_mvc.mak clean
::    TCL=%TCL64DIR% TCL_VER=%LIBTCLSHRT% TCL_VER_LONG=%LIBTCLLONG% DYNAMIC_TCL=yes
nmake /C /S /f Make_mvc.mak ^
    CPU=AMD64 DEBUG=no USE_MSVCRT=yes FEATURES=HUGE CHANNEL=yes MBYTE=yes CSCOPE=yes TERMINAL=yes IME=yes GIME=yes GUI=yes OLE=no  XPM=.\xpm\x64 DIRECTX=yes ^
    PERL=%PERL_DIR% DYNAMIC_PERL=yes PERL_VER=%LIBPERLVER% ^
    LUA="%LUA_DIR%" DYNAMIC_LUA=yes LUA_VER=%LIBLUASHRT% ^
    RUBY=%RUBY_DIR% DYNAMIC_RUBY=yes RUBY_VER=%LIBRBYSHRT% RUBY_VER_LONG=%LIBRBYLIB% RUBY_PLATFORM=x64-mswin64_140 RUBY_MSVCRT_NAME=msvcrt ^
    PYTHON=%PYTHON2_DIR% DYNAMIC_PYTHON=yes PYTHON_VER=%LIBPYTHON2% ^
    PYTHON3=%PYTHON3_DIR% DYNAMIC_PYTHON3=yes PYTHON3_VER=%LIBPYTHON3% ^
    MZSCHEME="%RACKET_DIR%" DYNAMIC_MZSCHEME=yes MZSCHEME_MAIN_LIB=racket MZSCHEME_VER=%LIBRACKET%

:: ren gvim.exe gvim_noOLE.exe
:: 
:: nmake /C /S /f Make_mvc.mak clean
:: nmake /C /S /f Make_mvc.mak ^
::     CPU=AMD64 DEBUG=no USE_MSVCRT=yes FEATURES=HUGE CHANNEL=yes MBYTE=yes CSCOPE=yes TERMINAL=yes IME=yes GIME=yes GUI=yes OLE=yes XPM=.\xpm\x64 DIRECTX=yes ^
::     PERL=%PERL_DIR% DYNAMIC_PERL=yes PERL_VER=%LIBPERLVER% ^
::     LUA="%LUA_DIR%" DYNAMIC_LUA=yes LUA_VER=%LIBLUASHRT% ^
::     TCL=%TCL64DIR% TCL_VER=%LIBTCLSHRT% TCL_VER_LONG=%LIBTCLLONG% DYNAMIC_TCL=yes ^
::     RUBY=%RUBY_DIR% DYNAMIC_RUBY=yes RUBY_VER=%LIBRBYSHRT% RUBY_VER_LONG=%LIBRBYLIB% RUBY_PLATFORM=x64-mswin64_140 RUBY_MSVCRT_NAME=msvcrt ^
::     PYTHON=%PYTHON2_DIR% DYNAMIC_PYTHON=yes PYTHON_VER=%LIBPYTHON2% ^
::     PYTHON3=%PYTHON3_DIR% DYNAMIC_PYTHON3=yes PYTHON3_VER=%LIBPYTHON3% ^
::     MZSCHEME="%RACKET_DIR%" DYNAMIC_MZSCHEME=yes MZSCHEME_MAIN_LIB=racket MZSCHEME_VER=%LIBRACKET%

nmake /C /S /f Make_mvc.mak clean
::    TCL=%TCL64DIR% TCL_VER=%LIBTCLSHRT% TCL_VER_LONG=%LIBTCLLONG% DYNAMIC_TCL=yes
nmake /C /S /f Make_mvc.mak ^
    CPU=AMD64 DEBUG=no USE_MSVCRT=yes FEATURES=HUGE CHANNEL=yes MBYTE=yes CSCOPE=yes TERMINAL=yes IME=no GIME=no GUI=no OLE=no XPM=.\xpm\x64 DIRECTX=no ^
    PERL=%PERL_DIR% DYNAMIC_PERL=yes PERL_VER=%LIBPERLVER% ^
    LUA="%LUA_DIR%" DYNAMIC_LUA=yes LUA_VER=%LIBLUASHRT% ^
    RUBY=%RUBY_DIR% DYNAMIC_RUBY=yes RUBY_VER=%LIBRBYSHRT% RUBY_VER_LONG=%LIBRBYLIB% RUBY_PLATFORM=x64-mswin64_140 RUBY_MSVCRT_NAME=msvcrt ^
    PYTHON=%PYTHON2_DIR% DYNAMIC_PYTHON=yes PYTHON_VER=%LIBPYTHON2% ^
    PYTHON3=%PYTHON3_DIR% DYNAMIC_PYTHON3=yes PYTHON3_VER=%LIBPYTHON3% ^
    MZSCHEME="%RACKET_DIR%" DYNAMIC_MZSCHEME=yes MZSCHEME_MAIN_LIB=racket MZSCHEME_VER=%LIBRACKET%


REM keep up the right directory structure
REM -------------------------------------

cd po
:: nmake -f Make_mvc.mak install-all
nmake -f Make_mvc.mak GETTEXT_PATH=d:\operation\gettext-0.14.4\bin install-all
cd ..

robocopy ..\runtime\ tempoutput\x64\ /MIR /NP /NJH /NJS /NFL /NDL
copy ..\vimtutor.* tempoutput\x64\
copy xxd\xxd.exe tempoutput\x64\
copy tee\tee.exe tempoutput\x64\
copy *.exe tempoutput\x64\
:: copy vimtbar.dll tempoutput\x64\
copy README.txt tempoutput\x64\

if not exist tempoutput\x64\GVimExt mkdir tempoutput\x64\GvimExt64
if not exist tempoutput\x64\VisVim mkdir tempoutput\x64\VisVim

copy gvimext\*.dll tempoutput\x64\GvimExt64\
copy gvimext\*.inf tempoutput\x64\GvimExt64\
copy gvimext\*.reg tempoutput\x64\GvimExt64\
copy gvimext\README.txt tempoutput\x64\GvimExt64\
copy /Y %GETTEXTDIR%\bin\libiconv-2.dll tempoutput\x64\GvimExt64\
copy /Y %GETTEXTDIR%\bin\libintl-8.dll  tempoutput\x64\GvimExt64\

copy VisVim\*.txt tempoutput\x64\VisVim\
copy VisVim\*.dll tempoutput\x64\VisVim\
copy VisVim\*.bat tempoutput\x64\VisVim\


copy %WINPTYDIR%\x64\bin\winpty.dll tempoutput\x64\winpty64.dll
copy %WINPTYDIR%\x64\bin\winpty-agent.exe tempoutput\x64\

if exist %PATCHDIFF%\patch.exe copy %PATCHDIFF%\patch.exe tempoutput\x64\
echo %PATCHDIFF%\diff.exe
if exist %PATCHDIFF%\diff.exe copy %PATCHDIFF%\diff.exe tempoutput\x64\

copy %PYTHON3_DIR%\python37.dll tempoutput\x64\

copy /Y %GETTEXTDIR%\bin\libiconv-2.dll tempoutput\x64\
copy /Y %GETTEXTDIR%\bin\libintl-8.dll  tempoutput\x64\


REM cleanup
REM ------------------------------------

del tempoutput\x64\vimlogo.*
del tempoutput\x64\*.png
del tempoutput\x64\vim??x??.*


REM pack it!
REM ------------------------------------

cd tempoutput\x64
7z a -mx=9 -r -bd ..\complete-x64.7z *
7z a -mx=9 -r -bd -sfx7z.sfx ..\complete-x64.exe *


REM ------------------------------------------------ DONE!


cd ..
cd ..
cd ..
cd ..

:upload

REM copy today's files into /upload
REM ------------------------------------

rd /S /Q ..\..\vim81
mkdir ..\..\vim81
:: robocopy vim\src\tempoutput\ upload\ /MAXAGE:1 /NP /NJH /NJS /NFL /NDL /SL /S
robocopy vim\src\tempoutput\%ARCH% ..\..\vim81\ /NP /NJH /NJS /NFL /NDL /SL /S /XD GvimExt64 GvimExt32 icons print VisVim /XF *.info *.desktop termcap vimtutor.com


REM -------------------------------------
REM make clean (manually)
if exist vim\src\tempoutput rd /S /Q vim\src\tempoutput

rd /S /Q vim\src\ObjCULYHRZAMD64\
rd /S /Q vim\src\ObjGXULYHRZAMD64\


