" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.config/nvim/autoload/plugged')

	Plug 'sheerun/vim-polyglot'	 " Better Syntax Support
	Plug 'jiangmiao/auto-pairs' 	" Auto pairs for '(' '[' '{'
    	Plug 'preservim/nerdcommenter'  " Easy multiline commenting tool
	" Plug 'neoclide/coc.nvim', {'branch': 'release'}     " a fast code completion engine
	
	" one dark theme
	Plug 'joshdick/onedark.vim' 
	Plug 'rakr/vim-one' 
	Plug 'tyrannicaltoucan/vim-deep-space'
	
call plug#end()
