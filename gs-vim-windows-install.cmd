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
call mklink "%HOME%\.vimrc.fork" "%APP_DIR%\.vimrc.fork"
call mklink "%HOME%\.vimrc.bundles" "%APP_DIR%\.vimrc.bundles"
call mklink "%HOME%\.vimrc.bundles.fork" "%APP_DIR%\.vimrc.bundles.fork"
call mklink "%HOME%\.vimrc.before" "%APP_DIR%\.vimrc.before"
call mklink "%HOME%\.vimrc.before.fork" "%APP_DIR%\.vimrc.before.fork"
REM call mklink "%HOME%\.vimrc.before.local" "%APP_DIR%\.vimrc.before.local"
call mklink "%HOME%\.gvimrc.local" "%APP_DIR%\.gvimrc.local"
call mklink "%HOME%\.vimrc.bundles.default" "%APP_DIR%\.vimrc.bundles.default"


REM IF NOT EXIST "%HOME%\.vim\bundle\neobundle.vim" (
REM     git clone git://github.com/Shougo/neobundle.vim.git %HOME%\.vim\bundle\neobundle.vim
REM ) ELSE (
REM     @set ORIGINAL_DIR=%CD%
REM     echo updating neobundle-vim
REM     chdir /d "%HOME%\.vim\bundle\neobundle.vim" 
REM     call git pull
REM     chdir /d "%ORIGINAL_DIR%"
REM )

REM call vim vim +NeoBundleInstall! +NeoBundleClean +q

IF NOT EXIST "%HOME%/.vim/bundle/vundle" (
    call git clone https://github.com/gmarik/vundle.git "%HOME%/.vim/bundle/vundle"
) ELSE (
  call cd "%HOME%/.vim/bundle/vundle"
  call git pull
  call cd %HOME%
)

call vim -u "%APP_PATH%/.vimrc.bundles.default" +BundleInstall! +BundleClean +qall 
