"Vi互換をオフにしてVimの機能を有効化する
set nocompatible

"プラグインの格納ディレクトリの場所を指定
set runtimepath+=$HOME/.vim,$HOME/.vim/after

"viminfoファイルの作成場所を指定
set viminfo+=n~/.viminfo

"スワップファイル(swp)の作成場所を指定
"windows/cygwinとその他環境で場所を分ける(cygwinはwin32unixとwin64unixか？)
if (has("win32") || has ("win64") || has("win32unix") || has ("win64unix"))
    set directory=C:/cygwin/tmp
else
    set directory=/tmp
endif

"ファイル内容が変更されると自動読み込みする
set autoread

"シンタックスハイライト
syntax on
"カラースキーマ
colorscheme torte

"カラースキーマ (要CSApprox.vim)
"colorscheme zenburn

"オートインデント
set autoindent

"空行のインデントを勝手に消さない
nnoremap o oX<C-h>
nnoremap O OX<C-h>
inoremap <CR> <CR>X<C-h>

" ヤンクをクリップボードへ送り込む
set clipboard+=unnamed

"編集中でもバッファを切り替えれるようにしておく
set hidden

"バッファ一覧ショートカット→バッファ番号で移動
nmap gb :ls<CR>:buf 

" ステータスエリア関係
"ステータスのところにファイル情報表示
set statusline=%<[%n]%F%=\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}\ %l,%c\ %P

"タブを空白で入力する
set expandtab

"行頭の余白内でTabを打ち込むと、'shiftwidth'の数だけインデントする
set smarttab

"標準タブは4
set tabstop=4
set softtabstop=4
set shiftwidth=4

"ビープ音を消す
"set visualbell
"ビープ音&ビジュアルベルを消す
set visualbell t_vb=

" 挿入モードでのカーソル移動
"inoremap <C-j> <Down>
"inoremap <C-k> <Up>
"inoremap <C-h> <Left>
"inoremap <C-l> <Right>

"標準文字コードをUTF-8に指定する
set encoding=utf-8

" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif
