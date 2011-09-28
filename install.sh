SYSTEM=gcc

if [ $1 ]; then
  SYSTEM=$1
fi

if [ `find ~/.vim/bundle -name 'vimproc.vim' | wc -l` -eq 0 ]; then
  cd ~/.vim/bundle && git clone https://github.com/Shougo/vimproc.git &> /dev/null; cd ~/.vim/bundle/vimproc && make -f "make_$SYSTEM.mak"
fi

if [ `find ~/.vim/bundle -name 'quickrun.vim' | wc -l` -eq 0 ]; then
  cd ~/.vim/bundle && git clone https://github.com/thinca/vim-quickrun.git &> /dev/null
fi
