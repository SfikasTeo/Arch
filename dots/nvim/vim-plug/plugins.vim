" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  	
	" autocmd VimEnter * PlugInstall
  	" autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')
	
	Plug 'jiangmiao/auto-pairs' 	" Auto pairs for '(' '[' '{'
    	Plug 'preservim/nerdcommenter'  " Easy multiline commenting tool
	Plug 'morhetz/gruvbox'
    	" Plug 'neoclide/coc.nvim', {'branch': 'release'}     " a fast code completion engine
	
call plug#end()
