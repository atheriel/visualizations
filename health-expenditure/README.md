<center>
![Sample Output](http://i.imgur.com/QNj7YQ7.png)
</center>

This is an illustration of using a spie chart, in this case for an extremely
unbalanced data set. The original blog post I wrote it for can be found
[here](http://unconj.ca/blog/visualizing-health-expenditure-using-spie-charts-and-r.html).

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
