" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

:filetype plugin on
:syntax on
:filetype indent on

