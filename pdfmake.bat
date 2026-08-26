set ARTICLE=main
xelatex -synctex=1 %ARTICLE%
bibtex %ARTICLE%
xelatex -synctex=1 %ARTICLE%
xelatex -synctex=1 %ARTICLE%
