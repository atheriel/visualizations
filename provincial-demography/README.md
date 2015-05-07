# Population Pyramids for Select Canadian Provinces, 2015-2035

<center>
![Sample Output](http://i.imgur.com/A5yKwAG.png)
</center>

## Building

You will require a recent version of R to run the script, an installation of
Make to run the Makefile (if you so desire), and an installation of the
ImageMagick program `convert` to correctly resize the resulting image. The
Makefile will attempt to download and compress the raw data automatically using
`wget`, `unzip`, and `xz`, but you can also download it manually from
[CANSIM](http://www20.statcan.gc.ca/tables-tableaux/cansim/csv/00520005-eng.zip)
and modify the `pop.R` script accordingly.

In addition, you must either supply the following or modify the `pyramids.R`
script to use something else:

* A file called `AUTHOR.txt` containing whatever you would like to appear in
  the attribution text.
* The `ggplot2`, `grid`, `gridExtra`, `dplyr`, and `showtext` R packages.
* The Minion Pro font.

Then, simply run `make` to regenerate the project, or run the R script
directly.

## Data Sources

The raw data come from Statistics Canada,
[CANSIM Table 052-0005](http://www5.statcan.gc.ca/cansim/a26?lang=eng&id=520005),
and can be redistributed under the terms of their
[Open License Agreement](http://www.statcan.gc.ca/eng/reference/licence-eng).

1. Statistics Canada. 2013. "Table 052-0005 - Projected population, by
   projection scenario, age and sex, as of July 1, Canada, provinces and
   territories, annual (persons)", CANSIM (database).

## License

All source code is licensed under the project license (see the LICENSE.txt in
the parent directory). The resulting original image has licensing information
embedded in the output, and should therefore be respected. Derivative works
should contain some measure of attribution, at your judgment.

The raw data is copyright Statistics Canada (2013), and is available for use
under the
[Statistics Canada Open License Agreement](http://www.statcan.gc.ca/eng/reference/licence-eng).
