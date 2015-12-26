"Vi�ߴ��򥪥դˤ���Vim�ε�ǽ��ͭ��������
set nocompatible

"�ץ饰����γ�Ǽ�ǥ��쥯�ȥ�ξ������
set runtimepath+=$HOME/.vim,$HOME/.vim/after

"viminfo�ե�����κ����������
set viminfo+=n~/.viminfo

"����åץե�����(swp)�κ����������
"windows/cygwin�Ȥ���¾�Ķ��Ǿ���ʬ����(cygwin��win32unix��win64unix����)
if (has("win32") || has ("win64") || has("win32unix") || has ("win64unix"))
    set directory=C:/cygwin/tmp
else
    set directory=/tmp
endif

"�ե��������Ƥ��ѹ������ȼ�ư�ɤ߹��ߤ���
set autoread

"���󥿥å����ϥ��饤��
syntax on
"���顼��������
colorscheme torte

"���顼�������� (��CSApprox.vim)
"colorscheme zenburn

"�����ȥ���ǥ��
set autoindent

"���ԤΥ���ǥ�Ȥ򾡼�˾ä��ʤ�
nnoremap o oX<C-h>
nnoremap O OX<C-h>
inoremap <CR> <CR>X<C-h>

" ��󥯤򥯥�åץܡ��ɤ��������
set clipboard+=unnamed

"�Խ���Ǥ�Хåե����ڤ��ؤ����褦�ˤ��Ƥ���
set hidden

"�Хåե��������硼�ȥ��åȢ��Хåե��ֹ�ǰ�ư
nmap gb :ls<CR>:buf 

" ���ơ��������ꥢ�ط�
"���ơ������ΤȤ���˥ե��������ɽ��
set statusline=%<[%n]%F%=\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}\ %l,%c\ %P

"���֤��������Ϥ���
set expandtab

"��Ƭ��;�����Tab���Ǥ�����ȡ�'shiftwidth'�ο���������ǥ�Ȥ���
set smarttab

"ɸ�ॿ�֤�4
set tabstop=4
set softtabstop=4
set shiftwidth=4

"�ӡ��ײ���ä�
"set visualbell
"�ӡ��ײ�&�ӥ��奢��٥��ä�
set visualbell t_vb=

" �����⡼�ɤǤΥ��������ư
"inoremap <C-j> <Down>
"inoremap <C-k> <Up>
"inoremap <C-h> <Left>
"inoremap <C-l> <Right>

"ɸ��ʸ�������ɤ�UTF-8�˻��ꤹ��
set encoding=utf-8

" ʸ�������ɤμ�ưǧ��
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconv��eucJP-ms���б����Ƥ��뤫������å�
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconv��JISX0213���б����Ƥ��뤫������å�
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodings����
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
  " ������ʬ
  unlet s:enc_euc
  unlet s:enc_jis
endif
" ���ܸ��ޤޤʤ����� fileencoding �� encoding ��Ȥ��褦�ˤ���
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" ���ԥ����ɤμ�ưǧ��
set fileformats=unix,dos,mac
" ���Ȥ�����ʸ�������äƤ⥫��������֤�����ʤ��褦�ˤ���
if exists('&ambiwidth')
  set ambiwidth=double
endif
