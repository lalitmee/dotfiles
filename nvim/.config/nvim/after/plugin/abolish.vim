try
  silent! call plug#load('vim-abolish')
catch
  finish
endtry

let g:abolish_save_file = expand('<sfile>')

if !exists(':Abolish')
  finish
endif

Abolish reciever{,s} receiver{}
Abolish teh the
Abolish cusror cursor
Abolish cosnt const
Abolish {hon,col}our{,s,ed,ing} {}or{}

" NOTE: taken from tjdevries
Abolish {p}y{o}bjext PyObject

" These are taken from tpope. Thanks!
Abolish anomol{y,ies}                         anomal{}
Abolish {,in}consistan{cy,cies,t,tly}         {}consisten{}
Abolish delimeter{,s}                         delimiter{}
Abolish {,non}existan{ce,t}                   {}existen{}
Abolish despara{te,tely,tion}                 despera{}
Abolish d{e,i}screp{e,a}nc{y,ies}             d{i}screp{a}nc{}
Abolish {,re}impliment{,s,ing,ed,ation}       {}implement{}
Abolish improvment{,s}                        improvement{}
Abolish inherant{,ly}                         inherent{}
Abolish lastest                               latest
Abolish catalgoue                             catalogue
Abolish persistan{ce,t,tly}                   persisten{}
Abolish seperat{e,es,ed,ing,ely,ion,ions,or}  separat{}
Abolish segument{,s,ed,ation}                 segment{}

Abolish e3n E3N

Abolish pattners patterns
Abolish configuratoin configuration

Abolish functoin function
Abolish funtcion function
Abolish functin function

Abolish cosntants constants
Abolish constnats constants

Abolish typgoraphy typography
Abolish tyopgraphy typography

Abolish respositories repositories

" Abolish Tqbf        The quick, brown fox jumps over the lazy dog
" Abolish Lidsa       Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum
