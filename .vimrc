" {
"   Main Contributor: zg
"   Version: 2.1
"   Created: 2012-01-20
"   Last Modified: 2017-01-19
" }

" Environment {
    set nocompatible " Get out of vi compatible mode
    " -> Platform Specific Setting
    " On Windows, also use .vim instead of vimfiles
    if has('win32') || has('win64')
        set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    endif
" }

" Customise gsvim settings for personal usage {
    if filereadable(expand($HOME . '/.vimrc.before'))
        source $HOME/.vimrc.before
    endif
" }

" Use bundles {
    if filereadable(expand($HOME . '/.vimrc.bundles'))
        source ~/.vimrc.bundles
    endif
" }

" Use bundles config {
    if filereadable(expand($HOME . '/.vimrc.bundles.local'))
        source ~/.vimrc.bundles.local
    endif
" }

" General {
    let mapleader=',' " Change the mapleader
    let maplocalleader='\' " Change the maplocalleader
    set timeoutlen=500 " Time to wait for a command
    set updatetime=250

    set autoread " Set autoread when a file is changed outside
    set autowrite " Write on make/shell commands
    set hidden " Turn on hidden"

    set history=1000 " Increase the lines of history
    set modeline " Turn on modeline
    set completeopt+=longest " Optimize auto complete
    set completeopt-=preview " Optimize auto complete

    set backup " Set backup
    set undofile " Set undo

    autocmd BufWinLeave *.* silent! mkview " Make Vim save view (state) (folds, cursor, etc)
    autocmd BufWinEnter *.* silent! loadview " Make Vim load view (state) (folds, cursor, etc)

    " No sound on errors
    set noerrorbells
    set novisualbell
    set t_vb=

    set viewoptions+=slash,unix " Better Unix/Windows compatibility
    set viewoptions-=options " in case of mapping change

    " -> User Interface
    " Set title
    set title
    set titlestring=%t%(\ %m%)%(\ (%{expand('%:p:h')})%)%(\ %a%)
    " Set status line
    if count(g:gsvim_bundle_groups, 'ui')
        set laststatus=2 " Show the statusline
        set noshowmode " Hide the default mode text
        set ttimeoutlen=50
    endif
    " Only have cursorline in current window and in normal window
    autocmd WinLeave * set nocursorline
    autocmd WinEnter * set cursorline
    autocmd InsertEnter * set nocursorline
    autocmd InsertLeave * set cursorline
    set wildmenu " Show list instead of just completing
    set wildmode=list:longest,full " Use powerful wildmenu
    set shortmess=at " Avoids hit enter
    set showcmd " Show cmd

    set backspace=indent,eol,start " Make backspaces delete sensibly
    set whichwrap+=h,l,<,>,[,] " Backspace and cursor keys wrap to
    set virtualedit=block,onemore " Allow for cursor beyond last character
    set scrolljump=5 " Lines to scroll when cursor leaves screen
    set scrolloff=3 " Minimum lines to keep above and below cursor
    set sidescroll=1 " Minimal number of columns to scroll horizontally
    set sidescrolloff=10 " Minimal number of screen columns to keep away from cursor

    set showmatch " Show matching brackets/parenthesis
    set matchtime=2 " Decrease the time to blink

    if g:gsvim_show_number
        set number " Show line numbers
        " Toggle relativenumber
        nnoremap <Leader>n :set relativenumber!<CR>
    endif

    set formatoptions+=rnlmM " Optimize format options
    set wrap " Set wrap
    set textwidth=76 " Change text width
    if g:gsvim_fancy_font
        set list " Show these tabs and spaces and so on
        " set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮ " Change listchars
        set listchars=tab:▶\ ,eol:¬,extends:❯,precedes:❮ " Change listchars
        set linebreak " Wrap long lines at a blank
        set showbreak=↪  " Change wrap line break
        set fillchars=diff:⣿,vert:│ " Change fillchars
        augroup trailing " Only show trailing whitespace when not in insert mode
            autocmd!
            autocmd InsertEnter * :set listchars-=trail:⌴
            autocmd InsertLeave * :set listchars+=trail:⌴
        augroup END
    endif
    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif
    " 设置 alt 键不映射到菜单栏
    set winaltkeys=no
    " clean no name empty buffers
    function! CleanNoNameEmptyBuffers()
        let buffers = filter(range(1, bufnr('$')),'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val) < 0 && (getbufline(v:val, 1, "$") == [""])')
        if !empty(buffers)
            exe 'bd '.join(buffers, ' ')
        else
            echo 'No buffer deleted'
        endif
    endfunction
    autocmd BufReadPre * call CleanNoNameEmptyBuffers()
    " -> Indent Related
    set autoindent " Preserve current indent on new lines
    set cindent " set C style indent
    set expandtab " Convert all tabs typed to spaces
    set softtabstop=4 " Indentation levels every four columns
    set shiftwidth=4 " Indent/outdent by four columns
    set shiftround " Indent/outdent to nearest tabstop
    " -> Search Related
    set ignorecase " Case insensitive search
    set smartcase " Case sensitive when uc present
    set hlsearch " Highlight search terms
    set incsearch " Find as you type search
    set gdefault " turn on g flag
    " -> Fold Related
    set foldlevelstart=0 " Start with all folds closed
    set foldcolumn=1 " Set fold column

    " Space to toggle and create folds.
    nnoremap <silent> <Space> @=(foldlevel('.') ? 'za' : '\<Space>')<CR>
    vnoremap <Space> zf

    " Set foldtext
    function! MyFoldText()
        let line=getline(v:foldstart)
        let nucolwidth=&foldcolumn+&number*&numberwidth
        let windowwidth=winwidth(0)-nucolwidth-3
        let foldedlinecount=v:foldend-v:foldstart+1
        let onetab=strpart('          ', 0, &tabstop)
        let line=substitute(line, '\t', onetab, 'g')
        let line=strpart(line, 0, windowwidth-2-len(foldedlinecount))
        let fillcharcount=windowwidth-len(line)-len(foldedlinecount)
        return line.'…'.repeat(' ',fillcharcount).foldedlinecount.'L'.' '
    endfunction
    set foldtext=MyFoldText()
    " -> Key Mapping
    " Use ,Space to toggle the highlight search
    nnoremap <Leader><Space> :set hlsearch!<CR>
    " Make j and k work the way you expect
    nnoremap j gj
    nnoremap k gk
    vnoremap j gj
    vnoremap k gk

    " Navigation between windows
    nnoremap <C-J> <C-W>j
    nnoremap <C-K> <C-W>k
    nnoremap <C-H> <C-W>h
    nnoremap <C-L> <C-W>l

    " Same when jumping around
    nnoremap g; g;zz
    nnoremap g, g,zz

    " Reselect visual block after indent/outdent
    vnoremap < <gv
    vnoremap > >gv

    " Repeat last substitution, including flags, with &.
    nnoremap & :&&<CR>
    xnoremap & :&&<CR>

    " Keep the cursor in place while joining lines
    nnoremap J mzJ`z

    " Select entire buffer
    nnoremap vaa ggvGg_

    " Strip all trailing whitespace in the current file
    nnoremap <Leader>q :%s/\s\+$//<CR>:let @/=''<CR>

    " Modify all the indents
    nnoremap \= gg=G

    " See the differences between the current buffer and the file it was loaded from
    command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
                \ | diffthis | wincmd p | diffthis

    " GUI Settings {
        " -> Colors and Fonts
        set background=dark " Set background
        if !has('gui_running')
            set t_Co=256 " Use 256 colors
        endif

        " GVIM- (here instead of .gvimrc)
        if has('gui_running')
            au GUIEnter * simalt ~x
            set guioptions-=m
            set guioptions-=l
            set guioptions-=L
            set guioptions-=r
            set guioptions-=T
            if has("gui_gtk2")
                set guifont=Courier\ 10\ Pitch\ 16
            elseif has("x11")
                set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
            elseif has("gui_win32")
                if g:gs_vim_font=='Ubuntu Mono derivative Powerline'
                    set guifont=Ubuntu\ Mono\ derivative\ Powerline:h13.8:cANSI
                    set guifontwide=微软雅黑:h11.6:w5.6:cGB2312
                elseif g:gs_vim_font=='DejaVu Sans Mono for Powerline'
                    "" set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h11.62:cANSI
                    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h12:cANSI
                    "" set guifontwide=微软雅黑:h11.623:w5.625:cGB2312
                    set guifontwide=幼圆:h12:w7.123:cGB2312
                elseif g:gs_vim_font=='Consolas'
                    set guifont=Consolas:h12.5:cANSI
                    set guifontwide=微软雅黑:h12.3:w5.2:cGB2312
                elseif g:gs_vim_font=='Fira Code'
                    set guifont=Fira\ Code:h11.5:cANSI
                    " set guifontwide=幼圆:h11:cGB2312
                endif
            endif
        endif
        " Vim UI
        if g:gs_vim_font=='DejaVu Sans Mono for Powerline'
            set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,nbsp:.,trail:• " Highlight problematic whitespace
            set showbreak=↪                                                 " Change wrap line break
        else
        ""elseif g:gs_vim_font=='Ubuntu Mono derivative Powerline'
            ""set listchars=tab:»\ ,eol:¬,extends:>,precedes:<,nbsp:.       " Highlight problematic whitespace
            ""set listchars=nbsp:¬,eol:¶,tab:>-,extends:»,precedes:«,trail:•
            set listchars=nbsp:.,eol:¬,tab:›\ ,extends:»,precedes:«,trail:•
            set showbreak=ˆ
        endif

        set linebreak                                                       " Wrap long lines at a blank
    " }
    " for error highlight
    highlight clear SpellBad
    highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
    highlight clear SpellCap
    highlight SpellCap term=underline cterm=underline
    highlight clear SpellRare
    highlight SpellRare term=underline cterm=underline
    highlight clear SpellLocal
    highlight SpellLocal term=underline cterm=underline
" }

" Local Setting {
    " Use local vimrc if available
    if filereadable(expand($HOME . '/.vimrc.local'))
        source $HOME/.vimrc.local
    endif
    " Use local gvimrc if available and gui is running
    if has('gui_running')
        if filereadable(expand($HOME . '/.gvimrc.local'))
            source $HOME/.gvimrc.local
        endif
    endif
" }

