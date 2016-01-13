autoload -U compinit
compinit
#compinit -u    #cygwinだと警告が出るので -u をつける←いつからかダメになった…
setopt auto_pushd
setopt auto_cd
setopt correct
setopt cdable_vars
autoload -U colors
colors
PROMPT='%~%% '

zstyle ':completion:*:default' menu select=1

HISTFILE=$HOME/.zsh-history           # 履歴をファイルに保存する
HISTSIZE=100000                       # メモリ内の履歴の数
SAVEHIST=100000                       # 保存される履歴の数
setopt extended_history               # 履歴ファイルに時刻を記録
function history-all { history -E 1 } # 全履歴の一覧を出力する
setopt share_history                  # 端末間での履歴の共有


PATH=/home/moriya/bin:${PATH}
PATH=${PATH}:/cygdrive/c/APPZ/xyzzy
PATH=${PATH}:/cygdrive/c/APPZ/emacs/bin
PATH=${PATH}:/cygdrive/c/APPZ/gvim
PATH=${PATH}:/cygdrive/c/APPZ/hyperestraier
PATH=/cygdrive/c/ruby-1.8.7-p249-i386-mswin32/bin:${PATH}


#色つけ
#eval `dircolors -c /etc/DIR_COLORS`   # csh 系
eval `dircolors -b /etc/DIR_COLORS`    # bsh 系

alias ls='ls --color=auto --show-control-chars'
alias rmbak='rm *.*~;rm *~;rm .*~'
alias svk='svk.bat'

#プロンプトテーマ
#autoload promptinit
#promptinit
#prompt adam1 cyan  #cygwinだと警告が出るようになってしまった

cd
