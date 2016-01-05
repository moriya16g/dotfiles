"ツールバーの非表示
:set guioptions-=T

"カラースキーマ
"colorscheme zenburn
colorscheme lucius
LuciusDark

"フォントとサイズ
"フォント名に日本語名を使うので、一時的に文字コードを変える
"このファイル (.gvimrc) の文字コードは utf-8 でなければならないので注意
set encoding=cp932
"set guifont=Consolas:h11,Ricty:h11 guifontwide=MS_Gothic:h11,Ricty:h11
set guifont=EcoCoding:h11
"set guifont=Anonymous\ Pro:h11
"set guifont=ARISAKA-等幅:h11
"set guifontwide=ＳＨ\ Ｇ30-M:h11
set guifontwide=ARISAKA-等幅:h11
set ambiwidth=double
set linespace=0
"文字コードを元に戻す
set encoding=utf8

"フォントレンダリングを綺麗に (Windows のみ)
set rop=type:directx,renmode:5,taamode:2
