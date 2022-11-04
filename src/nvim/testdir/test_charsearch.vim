" Test for character search commands - t, T, f, F, ; and ,

func Test_charsearch()
  enew!
  call append(0, ['Xabcdefghijkemnopqretuvwxyz',
	      \ 'Yabcdefghijkemnopqretuvwxyz',
	      \ 'Zabcdefghijkemnokqretkvwxyz'])
  " check that "fe" and ";" work
  1
  normal! ylfep;;p,,p
  call assert_equal('XabcdeXfghijkeXmnopqreXtuvwxyz', getline(1))
  " check that save/restore works
  2
  normal! ylfep
  let csave = getcharsearch()
  normal! fip
  call setcharsearch(csave)
  normal! ;p;p
  call assert_equal('YabcdeYfghiYjkeYmnopqreYtuvwxyz', getline(2))

  " check that setcharsearch() changes the settings.
  3
  normal! ylfep
  eval {'char': 'k'}->setcharsearch()
  normal! ;p
  call setcharsearch({'forward': 0})
  normal! $;p
  call setcharsearch({'until': 1})
  set cpo-=;
  normal! ;;p
  call assert_equal('ZabcdeZfghijkZZemnokqretkZvwxyz', getline(3))

  " check that repeating a search before and after a line fails
  normal 3Gfv
  call assert_beeps('normal ;')
  call assert_beeps('normal ,')

  " clear the character search
  call setcharsearch({'char' : ''})
  call assert_equal('', getcharsearch().char)

  call assert_fails("call setcharsearch([])", 'E715:')
  enew!
endfunc

" Test for character search in virtual edit mode with <Tab>
func Test_csearch_virtualedit()
  new
  set virtualedit=all
  call setline(1, "a\tb")
  normal! tb
  call assert_equal([0, 1, 2, 6], getpos('.'))
  set virtualedit&
  close!
endfunc

" Test for character search failure in latin1 encoding
func Test_charsearch_latin1()
  new
  let save_enc = &encoding
  " set encoding=latin1
  call setline(1, 'abcdefghijk')
  call assert_beeps('normal fz')
  call assert_beeps('normal tx')
  call assert_beeps('normal $Fz')
  call assert_beeps('normal $Tx')
  let &encoding = save_enc
  close!
endfunc

" vim: shiftwidth=2 sts=2 expandtab
