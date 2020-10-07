"set wrap linebreak nolist  " list disables linebreak
"set textwidth=80
"set wrapmargin=1
set encoding=utf-8
set list
set listchars=tab:→\ ,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
set number
set tabstop=2
set shiftwidth=2
let mapleader=","
if exists('&colorcolumn')
	set colorcolumn=80
endif
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"				for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"			for OpenVMS:  sys$login:.vimrc

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
map <F3> :execute "Ack " . expand("<cword>") . " ./" <Bar> cw<CR>

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
set ignorecase		" Do case insensitive matching
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
"if version < 600
"syntax clear
"elseif exists("b:current_syntax")
"finish
"endif

"syn match kivyPreProc       /#:.*/
"syn match kivyComment       /#.*/
"syn match kivyRule          /<\I\i*\(,\s*\I\i*\)*>:/
"syn match kivyAttribute     /\<\I\i*\>/ nextgroup=kivyValue

"syn include @pyth $VIMRUNTIME/syntax/python.vim
"syn region kivyValue start=":" end=/$/  contains=@pyth skipwhite

"syn region kivyAttribute matchgroup=kivyIdent start=/[\a_][\a\d_]*:/ end=/$/ contains=@pyth skipwhite

"if version >= 508 || !exists("did_python_syn_inits")
"if version <= 508
"let did_python_syn_inits = 1
"command -nargs=+ HiLink hi link <args>
"else
"command -nargs=+ HiLink hi def link <args>
"endif

"HiLink kivyPreproc      PreProc
"HiLink kivyComment      Comment
"HiLink kivyRule         Function
"HiLink kivyIdent        Statement
"HiLink kivyAttribute    Label
"delcommand HiLink
"endif
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
	"NeoBundle 'dkprice/vim-easygrep'
	NeoBundle 'mileszs/ack.vim'
	NeoBundle 'vim-airline/vim-airline'
	NeoBundle 'konfekt/fastfold'
	"Git support
	NeoBundle 'airblade/vim-gitgutter'
	NeoBundle 'tpope/vim-fugitive'
	"
	"Syntax support
	NeoBundle 'jiangmiao/auto-pairs'
	NeoBundle 'scrooloose/syntastic'
	NeoBundle 'tpope/vim-surround'
	NeoBundle 'ervandew/supertab'
	"NeoBundle 'nathanaelkane/vim-indent-guides'
	NeoBundle 'yggdroot/indentline'
	NeoBundle 'chiel92/vim-autoformat'
	"NeoBundle 'hublot/vim-gromacs'
	"NeoBundle 'Lokaltog/vim-easymotion'
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
	"NeoBundle 'honza/vim-snippets'
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
	" Dart - Flutter support
	NeoBundle 'dart-lang/dart-vim-plugin'
	"VueJS support
	NeoBundle 'leafoftree/vim-vue-plugin'
	NeoBundle 'pangloss/vim-javascript'
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

map <C-n> :NERDTreeToggle<CR>

"Android SDK
"let g:android_sdk_path = "/home/quyngan/Android/android-sdk-linux"
"let g:gradle_path = "/home/quyngan/Android/android-studio/gradle"
let g:pymode_lint_ignore = "E501, E265, E251, E116, E266"
"let g:ctrlp_working_path_mode = 'cr'
"let g:ctrlp_working_path
let g:ctrlp_working_path_mode = 'w'

" Silver searcher (remember to install ag searcher: `sudo apt install
" silversearcher-ag`)
let g:EasyGrepRoot = "search:.git,.svn"
let g:ackprg = 'ag --nogroup --nocolor --column'

" Indent character
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
"let g:indentLine_color_term = 239

" Fastfold:
nmap zuz <Plug>(FastFoldUpdate)
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']
let g:markdown_folding = 1
let g:tex_fold_enabled = 1
let g:vimsyn_folding = 'af'
let g:xml_syntax_folding = 1
let g:javaScript_fold = 1
let g:sh_fold_enabled= 7
let g:ruby_fold = 1
let g:perl_fold = 1
let g:perl_fold_blocks = 1
let g:r_syntax_folding = 1
let g:rust_fold = 1
let g:php_folding = 1

" Fugitive git support
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit -v -q<CR>
nnoremap <leader>ga :Gcommit --amend<CR>
nnoremap <leader>gt :Gcommit -v -q %<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gw :Gwrite<CR><CR>
nnoremap <leader>gl :silent! Glog<CR>
nnoremap <leader>gp :Ggrep<Space>
nnoremap <leader>gm :Gmove<Space>
nnoremap <leader>gb :Git branch<Space>
nnoremap <leader>go :Git checkout<Space>
nnoremap <leader>gps :Dispatch! git push<CR>
nnoremap <leader>gpl :Dispatch! git pull<CR>

"
" This file contains default settings and all format program definitions and links these to filetypes
"


" Vim-autoformat configuration variables
if !exists('g:autoformat_autoindent')
	let g:autoformat_autoindent = 1
endif

if !exists('g:autoformat_retab')
	let g:autoformat_retab = 1
endif

if !exists('g:autoformat_remove_trailing_spaces')
	let g:autoformat_remove_trailing_spaces = 1
endif

if !exists('g:autoformat_verbosemode')
	let g:autoformat_verbosemode = 0
endif


" Python
if !exists('g:formatdef_autopep8')
	" Autopep8 will not do indentation fixes when a range is specified, so we
	" only pass a range when there is a visual selection that is not the
	" entire file. See #125.
	let g:formatdef_autopep8 = '"autopep8 -".(g:DoesRangeEqualBuffer(a:firstline, a:lastline) ? " --range ".a:firstline." ".a:lastline : "")." ".(&textwidth ? "--max-line-length=".&textwidth : "")'
endif

" There doesn't seem to be a reliable way to detect if are in some kind of visual mode,
" so we use this as a workaround. We compare the length of the file against
" the range arguments. If there is no range given, the range arguments default
" to the entire file, so we return false if the range comprises the entire file.
function! g:DoesRangeEqualBuffer(first, last)
	return line('$') != a:last - a:first + 1
endfunction

" Yapf supports multiple formatter styles: pep8, google, chromium, or facebook
if !exists('g:formatter_yapf_style')
	let g:formatter_yapf_style = 'pep8'
endif
if !exists('g:formatdef_yapf')
	let s:configfile_def   = "'yapf -l '.a:firstline.'-'.a:lastline"
	let s:noconfigfile_def = "'yapf --style=\"{based_on_style:'.g:formatter_yapf_style.',indent_width:'.shiftwidth().(&textwidth ? ',column_limit:'.&textwidth : '').'}\" -l '.a:firstline.'-'.a:lastline"
	let g:formatdef_yapf   = "g:YAPFFormatConfigFileExists() ? (" . s:configfile_def . ") : (" . s:noconfigfile_def . ")"
endif

function! g:YAPFFormatConfigFileExists()
	return len(findfile(".style.yapf", expand("%:p:h").";")) || len(findfile("setup.cfg", expand("%:p:h").";")) || filereadable(exists('$XDG_CONFIG_HOME') ? expand('$XDG_CONFIG_HOME/yapf/style') : expand('~/.config/yapf/style'))
endfunction

if !exists('g:formatdef_black')
	let g:formatdef_black = '"black -q ".(&textwidth ? "-l".&textwidth : "")." -"'
endif

if !exists('g:formatters_python')
	let g:formatters_python = ['autopep8','yapf', 'black']
endif


" C#
if !exists('g:formatdef_astyle_cs')
	if filereadable('.astylerc')
		let g:formatdef_astyle_cs = '"astyle --mode=cs --options=.astylerc"'
	elseif filereadable(expand('~/.astylerc')) || exists('$ARTISTIC_STYLE_OPTIONS')
		let g:formatdef_astyle_cs = '"astyle --mode=cs"'
	else
		let g:formatdef_astyle_cs = '"astyle --mode=cs --style=ansi --indent-namespaces -pcH".(&expandtab ? "s".shiftwidth() : "t")'
	endif
endif

if !exists('g:formatters_cs')
	let g:formatters_cs = ['astyle_cs']
endif


" Generic C, C++, Objective-C
if !exists('g:formatdef_clangformat')
	let s:configfile_def = "'clang-format -lines='.a:firstline.':'.a:lastline.' --assume-filename=\"'.expand('%:p').'\" -style=file'"
	let s:noconfigfile_def = "'clang-format -lines='.a:firstline.':'.a:lastline.' --assume-filename=\"'.expand('%:p').'\" -style=\"{BasedOnStyle: WebKit, AlignTrailingComments: true, '.(&textwidth ? 'ColumnLimit: '.&textwidth.', ' : '').(&expandtab ? 'UseTab: Never, IndentWidth: '.shiftwidth() : 'UseTab: Always').'}\"'"
	let g:formatdef_clangformat = "g:ClangFormatConfigFileExists() ? (" . s:configfile_def . ") : (" . s:noconfigfile_def . ")"
endif

function! g:ClangFormatConfigFileExists()
	return len(findfile(".clang-format", expand("%:p:h").";")) || len(findfile("_clang-format", expand("%:p:h").";"))
endfunction



" C
if !exists('g:formatdef_astyle_c')
	if filereadable('.astylerc')
		let g:formatdef_astyle_c = '"astyle --mode=c --options=.astylerc"'
	elseif filereadable(expand('~/.astylerc')) || exists('$ARTISTIC_STYLE_OPTIONS')
		let g:formatdef_astyle_c = '"astyle --mode=c"'
	else
		let g:formatdef_astyle_c = '"astyle --mode=c --style=ansi -pcH".(&expandtab ? "s".shiftwidth() : "t")'
	endif
endif

if !exists('g:formatters_c')
	let g:formatters_c = ['clangformat', 'astyle_c']
endif


" C++
if !exists('g:formatdef_astyle_cpp')
	if filereadable('.astylerc')
		let g:formatdef_astyle_cpp = '"astyle --mode=c --options=.astylerc"'
	elseif filereadable(expand('~/.astylerc')) || exists('$ARTISTIC_STYLE_OPTIONS')
		let g:formatdef_astyle_cpp = '"astyle --mode=c"'
	else
		let g:formatdef_astyle_cpp = '"astyle --mode=c --style=ansi -pcH".(&expandtab ? "s".shiftwidth() : "t")'
	endif
endif

if !exists('g:formatters_cpp')
	let g:formatters_cpp = ['clangformat', 'astyle_cpp']
endif


" Objective C
if !exists('g:formatters_objc')
	let g:formatters_objc = ['clangformat']
endif


" D
if !exists('g:formatdef_dfmt')
	if executable('dfmt')
		let s:dfmt_command = 'dfmt'
	else
		let s:dfmt_command = 'dub run -q dfmt --'
	endif

	let s:configfile_def = '"' . s:dfmt_command . '"'
	let s:noconfigfile_def = '"' . s:dfmt_command . ' -t " . (&expandtab ? "space" : "tab") . " --indent_size " . shiftwidth() . (&textwidth ? " --soft_max_line_length " . &textwidth : "")'

	let g:formatdef_dfmt = 'g:EditorconfigFileExists() ? (' . s:configfile_def . ') : (' . s:noconfigfile_def . ')'
	let g:formatters_d = ['dfmt']
endif

function! g:EditorconfigFileExists()
	return len(findfile(".editorconfig", expand("%:p:h").";"))
endfunction


" Protobuf
if !exists('g:formatters_proto')
	let g:formatters_proto = ['clangformat']
endif


" Java
if !exists('g:formatdef_astyle_java')
	if filereadable('.astylerc')
		let g:formatdef_astyle_java = '"astyle --mode=java --options=.astylerc"'
	elseif filereadable(expand('~/.astylerc')) || exists('$ARTISTIC_STYLE_OPTIONS')
		let g:formatdef_astyle_java = '"astyle --mode=java"'
	else
		let g:formatdef_astyle_java = '"astyle --mode=java --style=java -pcH".(&expandtab ? "s".shiftwidth() : "t")'
	endif
endif

if !exists('g:formatters_java')
	let g:formatters_java = ['astyle_java']
endif


" Javascript
if !exists('g:formatdef_jsbeautify_javascript')
	if filereadable('.jsbeautifyrc')
		let g:formatdef_jsbeautify_javascript = '"js-beautify"'
	elseif filereadable(expand('~/.jsbeautifyrc'))
		let g:formatdef_jsbeautify_javascript = '"js-beautify"'
	else
		let g:formatdef_jsbeautify_javascript = '"js-beautify -X -".(&expandtab ? "s ".shiftwidth() : "t").(&textwidth ? " -w ".&textwidth : "")'
	endif
endif

if !exists('g:formatdef_jscs')
	let g:formatdef_jscs = '"jscs -x"'
endif

if !exists('g:formatdef_standard_javascript')
	let g:formatdef_standard_javascript = '"standard --fix --stdin"'
endif


if !exists('g:formatdef_prettier')
	let g:formatdef_prettier = '"prettier --stdin-filepath ".expand("%:p").(&textwidth ? " --print-width ".&textwidth : "")." --tab-width=".shiftwidth()'
endif


" This is an xo formatter (inspired by the above eslint formatter)
" To support ignore and overrides options, we need to use a tmp file
" So we create a tmp file here and then remove it afterwards
if !exists('g:formatdef_xo_javascript')
	function! g:BuildXOLocalCmd()
		let l:xo_js_tmp_file = fnameescape(tempname().".js")
		let content = getline('1', '$')
		call writefile(content, l:xo_js_tmp_file)
		return "xo --fix ".l:xo_js_tmp_file." 1> /dev/null; exit_code=$?
					\ cat ".l:xo_js_tmp_file."; rm -f ".l:xo_js_tmp_file."; exit $exit_code"
	endfunction
	let g:formatdef_xo_javascript = "g:BuildXOLocalCmd()"
endif

function! s:NodeJsFindPathToExecFile(exec_name)
	let l:path = fnamemodify(expand('%'), ':p')
	" find formatter & config file
	let l:prog = findfile('node_modules/.bin/'.a:exec_name, l:path.";")
	if empty(l:prog)
		let l:prog = findfile('~/.npm-global/bin/'.a:exec_name)
		if empty(l:prog)
			let l:prog = findfile('/usr/local/bin/'.a:exec_name)
		endif
	else
		let l:prog = getcwd()."/".l:prog
	endif
	return l:prog
endfunction

" Setup ESLint local. Setup is done on formatter execution if ESLint and
" corresponding config is found they are used, otherwiese the formatter fails.
" No windows support at the moment.
if !exists('g:formatdef_eslint_local')
	" returns unique file name near original
	function! g:BuildESLintTmpFile(path, ext)
		let l:i = 0
		let l:result = a:path.'_eslint_tmp_'.l:i.a:ext
		while filereadable(l:result) && l:i < 100000
			let l:i = l:i + 1
			let l:result = a:path.'_eslint_tmp_'.l:i.a:ext
		endwhile
		if filereadable(l:result)
			echoerr "Temporary file could not be created for ".a:path
			echoerr "Tried from ".a:path.'_eslint_tmp_0'.a:ext." to ".a:path.'_eslint_tmp_'.l:i.a:ext
			return ''
		endif
		return l:result
	endfunction

	function! g:BuildESLintLocalCmd()
		let l:path = fnamemodify(expand('%'), ':p')
		let l:ext = ".".expand('%:p:e')
		let verbose = &verbose || g:autoformat_verbosemode == 1
		if has('win32')
			return "(>&2 echo 'ESLint not supported on win32')"
		endif
		" find formatter & config file
		let l:prog = s:NodeJsFindPathToExecFile('eslint')

		"initial
		let l:cfg = findfile('.eslintrc.js', l:path.";")

		if empty(l:cfg)
			let l:cfg_fallbacks = [
						\'.eslintrc.yaml',
						\'.eslintrc.yml',
						\'.eslintrc.json',
						\'.eslintrc',
						\]

			for i in l:cfg_fallbacks
				let l:tcfg = findfile(i, l:path.";")
				if !empty(l:tcfg)
					break
				endif
			endfor

			if !empty(l:tcfg)
				let l:cfg = fnamemodify(l:tcfg, ":p")
			else
				let l:cfg = findfile('~/.eslintrc.js')
				for i in l:cfg_fallbacks
					if !empty(l:cfg)
						break
					endif
					let l:cfg = findfile("~/".i)
				endfor
			endif
		endif

		if (empty(l:cfg) || empty(l:prog))
			if verbose
				return "(>&2 echo 'No local or global ESLint program and/or config found')"
			endif
			return
		endif

		" This formatter uses a temporary file as ESLint has not option to print
		" the formatted source to stdout without modifieing the file.
		let l:eslint_tmp_file = g:BuildESLintTmpFile(l:path, l:ext)
		let content = getline('1', '$')
		call writefile(content, l:eslint_tmp_file)
		return l:prog." -c ".l:cfg." --fix ".l:eslint_tmp_file." 1> /dev/null; exit_code=$?
					\ cat ".l:eslint_tmp_file."; rm -f ".l:eslint_tmp_file."; exit $exit_code"
	endfunction
	let g:formatdef_eslint_local = "g:BuildESLintLocalCmd()"
endif

if !exists('g:formatters_javascript')
	let g:formatters_javascript = [
				\ 'eslint_local',
				\ 'jsbeautify_javascript',
				\ 'jscs',
				\ 'standard_javascript',
				\ 'prettier',
				\ 'xo_javascript',
				\ 'stylelint',
				\ ]
endif

" Vue
if !exists('g:formatters_vue')
	let g:formatters_vue = [
				\ 'eslint_local',
				\ 'stylelint',
				\ ]
endif

" JSON
if !exists('g:formatdef_jsbeautify_json')
	if filereadable('.jsbeautifyrc')
		let g:formatdef_jsbeautify_json = '"js-beautify"'
	elseif filereadable(expand('~/.jsbeautifyrc'))
		let g:formatdef_jsbeautify_json = '"js-beautify"'
	else
		let g:formatdef_jsbeautify_json = '"js-beautify -".(&expandtab ? "s ".shiftwidth() : "t")'
	endif
endif

if !exists('g:formatdef_fixjson')
	let g:formatdef_fixjson =  '"fixjson"'
endif

if !exists('g:formatters_json')
	let g:formatters_json = [
				\ 'jsbeautify_json',
				\ 'fixjson',
				\ 'prettier',
				\ ]
endif


" HTML
if !exists('g:formatdef_htmlbeautify')
	let g:formatdef_htmlbeautify = '"html-beautify - -".(&expandtab ? "s ".shiftwidth() : "t").(&textwidth ? " -w ".&textwidth : "")'
endif

if !exists('g:formatdef_tidy_html')
	let g:formatdef_tidy_html = '"tidy -q --show-errors 0 --show-warnings 0 --force-output --indent auto --indent-spaces ".shiftwidth()." --vertical-space yes --tidy-mark no -wrap ".&textwidth'
endif

if !exists('g:formatters_html')
	let g:formatters_html = ['htmlbeautify', 'tidy_html', 'stylelint']
endif



" XML
if !exists('g:formatdef_tidy_xml')
	let g:formatdef_tidy_xml = '"tidy -q -xml --show-errors 0 --show-warnings 0 --force-output --indent auto --indent-spaces ".shiftwidth()." --vertical-space yes --tidy-mark no -wrap ".&textwidth'
endif

if !exists('g:formatters_xml')
	let g:formatters_xml = ['tidy_xml']
endif

" SVG
if !exists('g:formatters_svg')
	let g:formatters_svg = ['tidy_xml']
endif

" XHTML
if !exists('g:formatdef_tidy_xhtml')
	let g:formatdef_tidy_xhtml = '"tidy -q --show-errors 0 --show-warnings 0 --force-output --indent auto --indent-spaces ".shiftwidth()." --vertical-space yes --tidy-mark no -asxhtml -wrap ".&textwidth'
endif

if !exists('g:formatters_xhtml')
	let g:formatters_xhtml = ['tidy_xhtml']
endif

" Ruby
if !exists('g:formatdef_rbeautify')
	let g:formatdef_rbeautify = '"rbeautify ".(&expandtab ? "-s -c ".shiftwidth() : "-t")'
endif

if !exists('g:formatdef_rubocop')
	" The pipe to sed is required to remove some rubocop output that could not
	" be suppressed.
	let g:formatdef_rubocop = "'rubocop --auto-correct -o /dev/null -s '.bufname('%').' \| sed -n 2,\\$p'"
endif

if !exists('g:formatters_ruby')
	let g:formatters_ruby = ['rbeautify', 'rubocop']
endif


" CSS

" Setup stylelint. Setup is done on formatter execution
" if stylelint is found, otherwise the formatter fails.
" No windows support at the moment.
if !exists('g:formatdef_stylelint')
	function! g:BuildStyleLintCmd()
		let verbose = &verbose || g:autoformat_verbosemode == 1
		if has('win32')
			return "(>&2 echo 'stylelint not supported on win32')"
		endif
		" find formatter
		let l:prog = s:NodeJsFindPathToExecFile('stylelint')

		if (empty(l:prog))
			if verbose
				return "(>&2 echo 'No local or global stylelint program found')"
			endif
			return
		endif

		return l:prog." --fix --stdin --stdin-filename ".bufname('%')
	endfunction
	let g:formatdef_stylelint = "g:BuildStyleLintCmd()"
endif


if !exists('g:formatdef_cssbeautify')
	let g:formatdef_cssbeautify = '"css-beautify -f - -s ".shiftwidth()'
endif

if !exists('g:formatters_css')
	let g:formatters_css = ['cssbeautify', 'prettier', 'stylelint']
endif

" SCSS
if !exists('g:formatdef_sassconvert')
	let g:formatdef_sassconvert = '"sass-convert -F scss -T scss --indent " . (&expandtab ? shiftwidth() : "t")'
endif

if !exists('g:formatters_scss')
	let g:formatters_scss = ['sassconvert', 'prettier', 'stylelint']
endif

" Less
if !exists('g:formatters_less')
	let g:formatters_less = ['prettier', 'stylelint']
endif

" Typescript
if !exists('g:formatdef_tsfmt')
	let g:formatdef_tsfmt = "'tsfmt --stdin '.bufname('%')"
endif

if !exists('g:formatters_typescript')
	let g:formatters_typescript = ['tsfmt', 'prettier']
endif

" Haxe
if !exists('g:formatdef_haxe_formatter')
	let g:formatdef_haxe_formatter = "'haxelib run formatter --stdin --source " . fnamemodify("%", ":p:h") . "'"
endif

if !exists('g:formatters_haxe')
	let g:formatters_haxe = ["haxe_formatter"]
endif

" Golang
" Two definitions are provided for two versions of gofmt.
" See issue #59
if !exists('g:formatdef_gofmt_1')
	let g:formatdef_gofmt_1 = '"gofmt -tabs=".(&expandtab ? "false" : "true")." -tabwidth=".shiftwidth()'
endif

if !exists('g:formatdef_gofmt_2')
	let g:formatdef_gofmt_2 = '"gofmt"'
endif

if !exists('g:formatdef_goimports')
	let g:formatdef_goimports = '"goimports"'
endif

if !exists('g:formatters_go')
	let g:formatters_go = ['gofmt_1', 'goimports', 'gofmt_2']
endif

" Rust
if !exists('g:formatdef_rustfmt')
	let g:formatdef_rustfmt = '"rustfmt --edition 2018"'
endif

if !exists('g:formatters_rust')
	let g:formatters_rust = ['rustfmt']
endif

" Dart
if !exists('g:formatdef_dartfmt')
	let g:formatdef_dartfmt = '"dartfmt"'
endif

if !exists('g:formatters_dart')
	let g:formatters_dart = ['dartfmt']
endif

" Perl
if !exists('g:formatdef_perltidy')
	" use perltidyrc file if readable
	if (has("win32") && (filereadable("perltidy.ini") ||
				\ filereadable($HOMEPATH."/perltidy.ini"))) ||
				\ ((has("unix") ||
				\ has("mac")) && (filereadable(".perltidyrc") ||
				\ filereadable(expand("~/.perltidyrc")) ||
				\ filereadable("/usr/local/etc/perltidyrc") ||
				\ filereadable("/etc/perltidyrc")))
		let g:formatdef_perltidy = '"perltidy -q -st"'
	else
		let g:formatdef_perltidy = '"perltidy --perl-best-practices --format-skipping -q "'
	endif
endif

if !exists('g:formatters_perl')
	let g:formatters_perl = ['perltidy']
endif

" Haskell
if !exists('g:formatdef_stylish_haskell')
	let g:formatdef_stylish_haskell = '"stylish-haskell"'
endif

if !exists('g:formatters_haskell')
	let g:formatters_haskell = ['stylish_haskell']
endif

" Purescript
if !exists('g:formatdef_purty')
	let g:formatdef_purty = '"purty -"'
endif

if !exists('g:formatters_purescript')
	let g:formatters_purescript = ['purty']
endif

" Markdown
if !exists('g:formatdef_remark_markdown')
	let g:formatdef_remark_markdown = '"remark --silent --no-color"'
endif

if !exists('g:formatters_markdown')
	let g:formatters_markdown = ['remark_markdown', 'prettier', 'stylelint']
endif

" Graphql
if !exists('g:formatters_graphql')
	let g:formatters_graphql = ['prettier']
endif

" Fortran
if !exists('g:formatdef_fprettify')
	let g:formatdef_fprettify = '"fprettify --no-report-errors --indent=".shiftwidth()'
endif

if !exists('g:formatters_fortran')
	let g:formatters_fortran = ['fprettify']
endif

" Elixir
if !exists('g:formatdef_mix_format')
	let g:formatdef_mix_format = '"mix format -"'
endif

if !exists('g:formatters_elixir')
	let g:formatters_elixir = ['mix_format']
endif

" Shell
if !exists('g:formatdef_shfmt')
	let g:formatdef_shfmt = '"shfmt -i ".(&expandtab ? shiftwidth() : "0")'
endif

if !exists('g:formatters_sh')
	let g:formatters_sh = ['shfmt']
endif

" SQL
if !exists('g:formatdef_sqlformat')
	let g:formatdef_sqlformat = '"sqlformat --reindent --indent_width ".shiftwidth()." --keywords upper --identifiers lower -"'
endif
if !exists('g:formatters_sql')
	let g:formatters_sql = ['sqlformat']
endif

" CMake
if !exists('g:formatdef_cmake_format')
	let g:formatdef_cmake_format = '"cmake-format - --tab-size ".shiftwidth()." ".(&textwidth ? "--line-width=".&textwidth : "")'
endif

if !exists('g:formatters_cmake')
	let g:formatters_cmake = ['cmake_format']
endif

" Latex
if !exists('g:formatdef_latexindent')
	let g:formatdef_latexindent = '"latexindent.pl -"'
endif

if !exists('g:formatters_latex')
	let g:formatters_tex = ['latexindent']
endif

" OCaml
if !exists('g:formatdef_ocp_indent')
	let g:formatdef_ocp_indent = '"ocp-indent"'
endif

if !exists('g:formatdef_ocamlformat')
	if filereadable('.ocamlformat')
		let g:formatdef_ocamlformat = '"ocamlformat --enable-outside-detected-project --name " . expand("%:p") . " -"'
	else
		let g:formatdef_ocamlformat = '"ocamlformat --profile=ocamlformat --enable-outside-detected-project --name " . expand("%:p") . " -"'
	endif
endif

if !exists('g:formatters_ocaml')
	let g:formatters_ocaml = ['ocamlformat', 'ocp_indent']
endif

" Assembly
if !exists('g:formatdef_asm_format')
	let g:formatdef_asm_format = '"asmfmt"'
endif

if !exists('g:formatters_asm')
	let g:formatters_asm = ['asm_format']
endif
