" Initial .vimrc based on recommendations from MIT's missing-semester course.
" Additional inspiration from vim-galore's minimal-vimrc

" Setting `nocompatible` switches from the default Vi-compatibility mode and
" enables useful Vim functionality. This configuration option turns out not to
" be necessary for the file named '~/.vimrc', because Vim automatically enters
" nocompatible mode if that file is present. But I'm including it here just in
" case this config file is loaded some other way (e.g. saved as `foo`, and then
" Vim started with `vim -u foo`).
set nocompatible

" Enable true color and a colorscheme
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
let g:gruvbox_contrast_dark = 'hard'
set background=dark
colorscheme gruvbox
" Background Color Erase fix for kitty terminal emulator
let &t_ut=''

" Show non-printable characters.
set list
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

set ttyfast     " fast(er) redrawing
set lazyredraw  " only redraw when necessary

" Turn on syntax highlighting.
syntax on
filetype plugin indent on " Load plugins according to detected filetype

" Auto-indent
set autoindent      " Indent according to previous line
set expandtab       " Uses spaces instead of tabs
set softtabstop=4   " Tab key inserts 4 spaces
set shiftwidth=4    " >> indents by 4 spaces
set shiftround      " >> indents to next multiple of 'shiftwidth'

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

set incsearch   " highlights as you search with / or ?
set wrapscan    " search wraps around end-of-file
"set hlsearch    " keeps matches highlighted

" Unbind some useless/annoying default key bindings.
nmap Q <Nop>    " Enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support.
set mouse+=a

" Try to prevent bad habits like using the arrow keys for movement
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
"inoremap <Left>  <ESC>:echoe "Use h"<CR>
"inoremap <Right> <ESC>:echoe "Use l"<CR>
"inoremap <Up>    <ESC>:echoe "Use k"<CR>
"inoremap <Down>  <ESC>:echoe "Use j"<CR>


""" My customizations """

"" Plugins ""

" vim-plug
call plug#begin()
  " The default plugin directory will be:
  "  - vim: '~/.vim/plugged'
  "  - neovim: stdpath('data') . '/plugged'
  " This can be customized by passing it as an argument:
  "  - e.g. 'call plug#begin('~/.vim/path/to/plugins')
  "  - avoid using standard vim directory names like 'plugin'

  " Make sure to use single quotes to specify plugins!

  " fish shell script highlighting and completion
  Plug 'nickeb96/fish.vim'

  " NERDTree file system explorer
  Plug 'preservim/nerdtree'

  " Tim Pope plugins
  Plug 'tpope/vim-fugitive'  " git plugin
  Plug 'tpope/vim-surround'

  " this call also executes `filetype plugin indent on` and `syntax on`
call plug#end()

" FZF Vim integration
"set rtp+=/usr/bin/fzf

" powerline/airline functionality
set rtp+=/usr/share/powerline/bindings/vim
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
"let g:airline_powerline_fonts = 1
"let g:airline_theme='gruvbox'

" NERDTree functionality
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
