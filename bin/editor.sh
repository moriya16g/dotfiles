#!/usr/bin/sh

# cygwin �R�}���h���C������ windows �n�G�f�B�^���A�����̃t�@�C���� Windows �n�̃p�X�ɕϊ����Ă���A���s����
FILE=`cygpath -w "${1}"`
"c:/APPZ/vim/gvim.exe" "$FILE"
