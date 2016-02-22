set wrap linebreak nolist  " list disables linebreak
set textwidth=80
set wrapmargin=1
set number
set shiftwidth=4
let mapleader=","
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Search through files
map <F4> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  "autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
runtime! debian.vim

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark
"color murphy

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""" Binary support """"""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " autocmds to automatically enter hex mode and handle file writes properly
" if has("autocmd")
"   " vim -b : edit binary using xxd-format!
"   augroup Binary
"     au!
" 
"     " set binary option for all binary files before reading them
"     au BufReadPre *.bin,*.hex setlocal binary
" 
"     " if on a fresh read the buffer variable is already set, it's wrong
"     au BufReadPost *
"           \ if exists('b:editHex') && b:editHex |
"           \   let b:editHex = 0 |
"           \ endif
" 
"     " convert to hex on startup for binary files automatically
"     au BufReadPost *
"           \ if &binary | Hexmode | endif
" 
"     " When the text is freed, the next time the buffer is made active it will
"     " re-read the text and thus not match the correct mode, we will need to
"     " convert it again if the buffer is again loaded.
"     au BufUnload *
"           \ if getbufvar(expand("<afile>"), 'editHex') == 1 |
"           \   call setbufvar(expand("<afile>"), 'editHex', 0) |
"           \ endif
" 
"     " before writing a file when editing in hex mode, convert back to non-hex
"     au BufWritePre *
"           \ if exists("b:editHex") && b:editHex && &binary |
"           \  let oldro=&ro | let &ro=0 |
"           \  let oldma=&ma | let &ma=1 |
"           \  silent exe "%!xxd -r" |
"           \  let &ma=oldma | let &ro=oldro |
"           \  unlet oldma | unlet oldro |
"           \ endif
" 
"     " after writing a binary file, if we're in hex mode, restore hex mode
"     au BufWritePost *
"           \ if exists("b:editHex") && b:editHex && &binary |
"           \  let oldro=&ro | let &ro=0 |
"           \  let oldma=&ma | let &ma=1 |
"           \  silent exe "%!xxd" |
"           \  exe "set nomod" |
"           \  let &ma=oldma | let &ro=oldro |
"           \  unlet oldma | unlet oldro |
"           \ endif
"   augroup END
" endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    silent :e " this will reload the file without trickeries 
              "(DOS line endings will be shown entirely )
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction
nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <Esc>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmode<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""" Kivy for vim """"""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match kivyPreProc       /#:.*/
syn match kivyComment       /#.*/
syn match kivyRule          /<\I\i*\(,\s*\I\i*\)*>:/
syn match kivyAttribute     /\<\I\i*\>/ nextgroup=kivyValue

syn include @pyth $VIMRUNTIME/syntax/python.vim
syn region kivyValue start=":" end=/$/  contains=@pyth skipwhite

syn region kivyAttribute matchgroup=kivyIdent start=/[\a_][\a\d_]*:/ end=/$/ contains=@pyth skipwhite

if version >= 508 || !exists("did_python_syn_inits")
  if version <= 508
    let did_python_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

    HiLink kivyPreproc      PreProc
    HiLink kivyComment      Comment
    HiLink kivyRule         Function
    HiLink kivyIdent        Statement
    HiLink kivyAttribute    Label
  delcommand HiLink
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" NeoBundle Vim package manager
" if !1 | finish | endif

if has('vim_starting')

	" Required:
	set runtimepath+=~/.vim/bundle/neobundle.vim/

	" Required:
	call neobundle#begin(expand('~/.vim/bundle/'))
	
	" Let NeoBundle manage NeoBundle
	" Required:
	NeoBundle 'Shougo/neobundle.vim'
	NeoBundle 'Shougo/unite.vim'
	
	" My Bundles here:
	
	"NeoBundle 'derekwyatt/vim-scala'
	NeoBundle 'ctrlpvim/ctrlp.vim'
	NeoBundle 'scrooloose/nerdtree'
	NeoBundle 'scrooloose/nerdcommenter'
	NeoBundle 'tpope/vim-obsession'
	NeoBundle 'jiangmiao/auto-pairs'
	"
	"Syntax support
	"NeoBundleLazy 'scrooloose/syntastic'
	NeoBundle 'tpope/vim-surround'
	NeoBundle 'ervandew/supertab'
	"NeoBundleLazy 'nathanaelkane/vim-indent-guides'
	"NeoBundle 'Yggdroot/indentLine'
	"NeoBundleLazy 'hublot/vim-gromacs'
	"NeoBundleLazy 'Lokaltog/vim-easymotion'
	"
	"Python support
	NeoBundle 'klen/python-mode'
	"NeoBundle 'kivy/kivy'
	"NeoBundle 'farfanoide/vim-kivy'
	"
	"HTML support
	"NeoBundle 'mattn/emmet-vim'
	"NeoBundle 'msanders/snipmate.vim'
	"NeoBundle 'garbas/vim-snipmate'
	"NeoBundle 'MarcWeber/vim-addon-mw-utils'
	"NeoBundle 'tomtom/tlib_vim'
	NeoBundle 'honza/vim-snippets'
	"
	"Angular support
	"NeoBundle 'burnettk/vim-angular'
	"NeoBundle 'matthewsimo/angular-vim-snippets'
	"
	"Android Java
	"NeoBundle 'JetBrains/ideavim'
	"NeoBundle 'mbrubeck/android-completion'
	"NeoBundle 'hsanson/vim-android'
	"
	"Latex support
	"NeoBundleLazy 'vimsripts/latex-support.vim'
	"NeoBundle 'vim-latex/vim-latex'
	"NeoBundleSource
	" Refer to |:NeoBundle-examples|.
	" Note: You don't set neobundle setting in .gvimrc!

	call neobundle#end()

endif
" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently promp you to install them.
NeoBundleCheck
"let g:indentLine_color_term = 239

map <C-n> :NERDTreeToggle<CR>

"Android SDK
let g:android_sdk_path = "/home/quyngan/Android/android-sdk-linux"
let g:gradle_path = "/home/quyngan/Android/android-studio/gradle"
let g:pymode_lint_ignore = "E501"
