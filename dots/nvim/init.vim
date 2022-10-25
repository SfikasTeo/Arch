"Sourcing
source $HOME/.config/nvim/vim-plug/plugins.vim
source $HOME/.config/nvim/themes/onedark.vim	" colorscheme

" --------------- THEME ---------------

	" General visuals
	syntax enable			" Same as syntax on - default
	set number 			" add line numbers
	set cursorline			" highlight current cursorline
	set nowrap			" Long lines not wrapped
	
	" Current colorscheme
  	set termguicolors
	
" --------------- GENERAL SETTINGS ---------------
	" General
	set nocompatible		" disable compatibility to old-time vi
	set so=999			" Smooth scroll
	set wildmode=longest,list   	" get bash-like tab completions
	set mouse=a                 	" enable mouse click
	set clipboard+=unnamedplus   	" using system clipboard
	set pumheight=10                " Makes popup menu smaller
	set cmdheight=2                 " More space for displaying messages
	set conceallevel=0              " So that I can see `` in markdown files
	set hidden                      " Required to keep multiple buffers open multiple buffers
	
	" open new split panes to right and below
	set splitright			" Horizontal splits will automatically be below
	set splitbelow		        " Vertical splits will automatically be to the right
	
	" default encoding
	set encoding=utf-8
	set fileencoding=utf-8
	
	" 256 colors support
	set t_Co=256
	
	" Tabs
	set autoindent			" indent a new line the same amount as the line just typed
	set smartindent			" autoindent with C like language suport
	set tabstop=4			" number of columns occupied by a tab 
	set softtabstop=4		" see multiple spaces as tabstops so <BS> does the right thing
	set expandtab			" converts tabs to white space
	set smarttab                    " Makes tabbing smarter will realize you have 2 vs 4
	set shiftwidth=4		" width for autoindents
	
	
	" Determines filetype  
	filetype plugin indent on   	" allow auto-indenting depending on file type

	" No BackUps	
	set noswapfile			" disable creating swap file
	set nobackup			" disable backup
	set nowritebackup		" disable writing on backups
	
	" Searching
	set showmatch			" show matching - No fucking idea
	set hlsearch			" highlight search 
	set incsearch			" incremental search

" --------------- STATUS LINE ---------------
	
	set statusline=
	set statusline+=\ %M		" Shows "+" if changes have been made
	set statusline+=\ %y		" Display the filetype in use
	set statusline+=\ %r		" Display Read-Only indicator

	set statusline+=%=		" Print anything after this to the right
	set statusline+=\ %c:%l/%L	" Print Column:Line/Total Lines
	set statusline+=\ [%n]		" Display buffer number ( Tab counter )
	
" --------------- KEYBINDS ---------------

" Insert mode keybindings
	:inoremap ii <Esc>
	inoremap <C-c> <C-o>yy
	inoremap <C-x> <C-o>dd
	inoremap <C-v> <C-o>p
	
" Navigate during insert mode
	inoremap <C-h> <C-o>h
	inoremap <C-j> <C-o>j
	inoremap <C-k> <C-o>k
	inoremap <C-l> <C-o>l
   
" Quit And Save from everymode
	nnoremap <C-w> <C-o>:x
	inoremap <C-w> <C-o>:x
	vnoremap <C-w> <C-o>:x
   
	nnoremap <C-q> <C-o>:q!
	inoremap <C-q> <C-o>:q!
	vnoremap <C-q> <C-o>:q!

" Undo most recent change
	nnoremap <C-z> <C-o>u
	inoremap <C-z> <C-o>u
	vnoremap <C-z> <C-o>u
         
" --------------- END ---------------
