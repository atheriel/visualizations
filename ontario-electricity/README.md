<center>
![Sample Output](http://i.imgur.com/A5yKwAG.png)
</center>

This is my take on what is sometimes called a waffle chart. It's inspired by
an old NYT visualization on household debt.

## Building

You will require a recent version of R to run the script, an installation of
Make to run the Makefile (if you so desire), and an installation of the
ImageMagick program `convert` to correctly resize the resulting image.

In addition, you must either supply the following or modify the R script to
use something else:

* A file called `AUTHOR.txt` containing whatever you would like to appear in
  the attribution text.
* The `ggplot2`, `grid`, `gridExtra`, `dplyr`, `data.table`, and `showtext` R
  packages.
* The Minion Pro and Zapfino fonts.

Then, simply run `make` to regenerate the project, or run the R script
directly.
