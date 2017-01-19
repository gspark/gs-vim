REM    Copyleft 2012 zg 

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
REM call mklink "%HOME%\.gvimrc.local" "%APP_DIR%\.gvimrc.local"

call mklink "%HOME%\.editorconfig" 	"%APP_DIR%\.editorconfig"
call mklink "%HOME%\.jshintrc" 		"%APP_DIR%\rc\.jshintrc"
call mklink "%HOME%\.jscsrc" 		"%APP_DIR%\rc\.jscsrc"
call mklink "%HOME%\.eslintrc" 		"%APP_DIR%\rc\.eslintrc"

call curl -fLo %HOME%\.vim\autoload\plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

set VIM=e:\opt\vim\vim80\vim.exe
call %VIM% +PlugUpdate +qal

