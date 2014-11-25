# Public Health Expenditure, by Age Group in Canada

This is an illustration of using a spie chart, in this case for an extremely
unbalanced data set. The original blog post I wrote it for can be found
[here](http://unconj.ca/blog/visualizing-health-expenditure-using-spie-charts-and-r.html).

<center>
![Sample Output](http://i.imgur.com/QNj7YQ7.png)
</center>

## Building

You will require a recent version of R to run the script, an installation of
Make to run the Makefile (if you so desire), and an installation of the
ImageMagick program `convert` to correctly resize the resulting image.

In addition, you must either supply the following or modify the R script to
use something else:

* A file called `AUTHOR.txt` containing whatever you would like to appear in
  the attribution text.
* The `ggplot2`, `grid`, `gridExtra`, and `showtext` R packages.
* The Minion Pro and Myriad Pro fonts.

Then, simply run `make` to regenerate the project, or run the R script
directly.

## Data Sources

The raw data come from the following publication:

1. Canadian Institution for Health Information. 2013. "National Health
   Expenditure Trends", Table E.1.14 and Appendix C.17. Available
   [online](https://secure.cihi.ca/estore/productFamily.htm?locale=en&pf=PFC2400).

Which permits redistribution with attribution.

## License

All source code is licensed under the project license (see the LICENSE.txt in
the parent directory). The resulting original image has licensing information
embedded in the output, and should therefore be respected. Derivative works
should contain some measure of attribution, at your judgment.

The raw data is copyright Canadian Institute for Health Information (2013), and
may be redistributed in this form.
