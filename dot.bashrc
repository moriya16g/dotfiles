# History Options
# Don't put duplicate lines in the history.
export HISTCONTROL="ignoredups"
# Ignore some controlling instructions
export HISTIGNORE="[   ]*:&:bg:fg:exit"
function share_history {  # 以下の内容を関数として定義
    history -a  # .bash_historyに前回コマンドを1行追記
    history -c  # 端末ローカルの履歴を一旦消去
    history -r  # .bash_historyから履歴を読み込み直す
}
PROMPT_COMMAND='share_history'  # 上記関数をプロンプト毎に自動実施
shopt -u histappend    # .bash_history追記モードは不要なのでOFFに
export HISTSIZE=333333 # 履歴のMAX保存数を指定


# additional path
# path="$(cygpath -au "$path")"
PATH=/usr/local/bin:"$PATH"

# Some neat aliases
alias rmbak=" rm -f .*~;rm -f *.*~ *~ #*"
alias ls='ls --color=auto --show-control-chars'
alias grep='grep --color'

# 日本語化
export LANG=ja_JP.UTF8
set kanji-code sjis
set convert-meta off
set meta-flag on
set output-meta on

# タイムゾーン設定
export TZ=JST-9

# プロンプトのカスタマイズ
#export PS1="[\w]\$ "
export PS1="\[\e[1;33m\]\u@\h:\[\e[00m\]\W\$ " #for screen

# ruby
alias ri='ri -f ansi'

# lv
export PAGER="lv -c"

cd

##### For cygwin
# color
#eval `dircolors -c /etc/DIR_COLORS`   # csh
eval `dircolors -b /etc/DIR_COLORS`    # bsh
# additional path
PATH=/cygdrive/c/APPZ/vim:/cygdrive/c/APPZ/xyzzy:/cygdrive/c/APPZ/emacs/bin:"$PATH" #Editor
PATH=/cygdrive/c/APPZ/hyperestraier:"$PATH" #HyperEastraier
PATH=/home/moriya/bin:"$PATH"
# aliases
alias emacs=runemacs
# variables
export TERM=cygwin
