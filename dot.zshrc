autoload -U compinit
compinit
#compinit -u    #cygwin���ƌx�����o��̂� -u �����適�����炩�_���ɂȂ����c
setopt auto_pushd
setopt auto_cd
setopt correct
setopt cdable_vars
autoload -U colors
colors
PROMPT='%~%% '

zstyle ':completion:*:default' menu select=1

HISTFILE=$HOME/.zsh-history           # �������t�@�C���ɕۑ�����
HISTSIZE=100000                       # ���������̗����̐�
SAVEHIST=100000                       # �ۑ�����闚���̐�
setopt extended_history               # �����t�@�C���Ɏ������L�^
function history-all { history -E 1 } # �S�����̈ꗗ���o�͂���
setopt share_history                  # �[���Ԃł̗����̋��L


PATH=/home/moriya/bin:${PATH}
PATH=${PATH}:/cygdrive/c/APPZ/xyzzy
PATH=${PATH}:/cygdrive/c/APPZ/emacs/bin
PATH=${PATH}:/cygdrive/c/APPZ/gvim
PATH=${PATH}:/cygdrive/c/APPZ/hyperestraier
PATH=/cygdrive/c/ruby-1.8.7-p249-i386-mswin32/bin:${PATH}


#�F��
#eval `dircolors -c /etc/DIR_COLORS`   # csh �n
eval `dircolors -b /etc/DIR_COLORS`    # bsh �n

alias ls='ls --color=auto --show-control-chars'
alias rmbak='rm *.*~;rm *~;rm .*~'
alias svk='svk.bat'

#�v�����v�g�e�[�}
#autoload promptinit
#promptinit
#prompt adam1 cyan  #cygwin���ƌx�����o��悤�ɂȂ��Ă��܂���

cd
