# Ontario's Electricity Generation

This is my take on what is sometimes called a waffle chart. It's inspired by
[an old NYT visualization on household debt](http://www.nytimes.com/imagepages/2008/07/20/business/20080720_DEBT.html).

<center>
![Sample Output](http://i.imgur.com/A5yKwAG.png)
</center>

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

## Data Sources

The raw data come from the following publication:

1. Ontario Power Authority. 2013. "Achieving Balance: Ontario's Long-Term
   Energy Plan", p. 9. Available
   [online]http://www.energy.gov.on.ca/en/files/2014/10/LTEP_2013_English_WEB.pdf).

The inclusion of the data in the script here is for research purposes and so it
should qualify as fair dealing in Canada (and many other jurisdictions).

## License

All source code is licensed under the project license (see the LICENSE.txt in
the parent directory). The resulting original image has licensing information
embedded in the output, and should therefore be respected. Derivative works
should contain some measure of attribution, at your judgment.

The raw data is copyright Ontario Power Authority (2013), but can probably be
redistributed in this form under fair dealings (or fair use) provisions.
