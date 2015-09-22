REM    Copyright 2014 Steve Francia
REM 
REM    Licensed under the Apache License, Version 2.0 (the "License");
REM    you may not use this file except in compliance with the License.
REM    You may obtain a copy of the License at
REM 
REM        http://www.apache.org/licenses/LICENSE-2.0
REM 
REM    Unless required by applicable law or agreed to in writing, software
REM    distributed under the License is distributed on an "AS IS" BASIS,
REM    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
REM    See the License for the specific language governing permissions and
REM    limitations under the License.

set HOME=e:\opt\vim\.home

@set APP_DIR=%HOME%\gs-vim
IF NOT EXIST "%APP_DIR%" (
  call git clone --recursive https://github.com/gspark/gs-vim.git "%APP_DIR%"
) ELSE (
    @set ORIGINAL_DIR=%CD%
    echo updating gs-vim
    chdir /d "%APP_DIR%" 
    call git pull
    chdir /d "%ORIGINAL_DIR%"
    call cd "%APP_DIR%" 
)

call mklink "%HOME%\.vimrc" "%APP_DIR%\.vimrc"
REM call mklink "%HOME%\.vimrc.fork" "%APP_DIR%\.vimrc.fork"
REM call mklink "%HOME%\.vimrc.bundles" "%APP_DIR%\.vimrc.bundles"
REM call mklink "%HOME%\.vimrc.bundles.fork" "%APP_DIR%\.vimrc.bundles.fork"
call mklink "%HOME%\.vimrc.before" "%APP_DIR%\.vimrc.before"
call mklink "%HOME%\.vimrc.bundles.local" "%APP_DIR%\.vimrc.bundles.local"
call mklink "%HOME%\.vimrc.local" "%APP_DIR%\.vimrc.local"
call mklink "%HOME%\.gvimrc.local" "%APP_DIR%\.gvimrc.local"
call mklink "%HOME%\.jshintrc" "%APP_DIR%\.jshintrc"
call mklink "%HOME%\.jscsrc" "%APP_DIR%\.jscsrc"

IF NOT EXIST "%HOME%\.vim\bundle\neobundle.vim" (
    git clone git://github.com/Shougo/neobundle.vim.git %HOME%\.vim\bundle\neobundle.vim
) ELSE (
    @set ORIGINAL_DIR=%CD%
    echo updating neobundle-vim
    chdir /d "%HOME%\.vim\bundle\neobundle.vim" 
    call git pull
    chdir /d "%ORIGINAL_DIR%"
)

set VIM=e:\opt\vim\vim74\vim.exe
call %VIM% vim +NeoBundleInstall! +NeoBundleClean +q

