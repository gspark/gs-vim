REM    Copyleft 2012 zg

set HOME=d:\ops\vim\.home

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
call mklink "%HOME%\.vimrc.bundles" "%APP_DIR%\.vimrc.bundles"
REM call mklink "%HOME%\.vimrc.bundles.fork" "%APP_DIR%\.vimrc.bundles.fork"
call mklink "%HOME%\.vimrc.before" "%APP_DIR%\.vimrc.before"
call mklink "%HOME%\.vimrc.bundles.local" "%APP_DIR%\.vimrc.bundles.local"
call mklink "%HOME%\.vimrc.local" "%APP_DIR%\.vimrc.local"
REM call mklink "%HOME%\.gvimrc.local" "%APP_DIR%\.gvimrc.local"

call mklink "%HOME%\.editorconfig"      "%APP_DIR%\.editorconfig"
call mklink "%HOME%\.jshintrc"          "%APP_DIR%\rc\.jshintrc"
call mklink "%HOME%\.jscsrc"            "%APP_DIR%\rc\.jscsrc"
call mklink "%HOME%\.eslintrc"          "%APP_DIR%\rc\.eslintrc"

call curl -fLo %HOME%\.vim\autoload\plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

REM set VIM=e:\opt\vim\vim80\vim.exe
REM call %VIM% +PlugUpdate +qal

rem mklink /J "d:\ops\vim\.vim\.coc\extensions\coc-sumneko-lua-data\sumneko-lua-ls\extension\server\log" "z:\TEMP\vim"
mklink "d:\ops\vim\vim90\vim.exe" "d:\ops\vim\vim90\gvim.exe"
