# History Options
# Don't put duplicate lines in the history.
export HISTCONTROL="ignoredups"
# Ignore some controlling instructions
export HISTIGNORE="[   ]*:&:bg:fg:exit"
function share_history {  # �ȉ��̓��e���֐��Ƃ��Ē�`
    history -a  # .bash_history�ɑO��R�}���h��1�s�ǋL
    history -c  # �[�����[�J���̗�������U����
    history -r  # .bash_history���痚����ǂݍ��ݒ���
}
PROMPT_COMMAND='share_history'  # ��L�֐����v�����v�g���Ɏ������{
shopt -u histappend    # .bash_history�ǋL���[�h�͕s�v�Ȃ̂�OFF��
export HISTSIZE=333333 # ������MAX�ۑ������w��


# additional path
# path="$(cygpath -au "$path")"
PATH=/usr/local/bin:"$PATH"

# Some neat aliases
alias rmbak=" rm -f .*~;rm -f *.*~ *~ #*"
alias ls='ls --color=auto --show-control-chars'
alias grep='grep --color'

# ���{�ꉻ
export LANG=ja_JP.UTF8
set kanji-code sjis
set convert-meta off
set meta-flag on
set output-meta on

# �^�C���]�[���ݒ�
export TZ=JST-9

# �v�����v�g�̃J�X�^�}�C�Y
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
