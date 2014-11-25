# Australia's National Public Toilet Dataset

This is a simple population map that makes use of hexbins to deal with
overplotting.

<center>
![Sample Output](http://i.imgur.com/6UGuxyI.png)
</center>

## Building

You will require a recent version of R to run the script, an installation of
Make to run the Makefile (if you so desire), and an installation of the
ImageMagick program `convert` to correctly resize the resulting image.

In addition, you must either supply the following or modify the R script to
use something else:

* A file called `AUTHOR.txt` containing whatever you would like to appear in
  the attribution text.
* The `ggplot2`, `grid`, `gridExtra`, `dplyr`, and `showtext` R packages.
* The Minion Pro and Envy Code R fonts.

Then, simply run `make` to regenerate the project, or run the R script
directly.

## Data Sources

The raw data file comes from the Government of Australia's `data.gov.au`
website, and is licensed under the
[Creative Commons Attribution 3.0 Australia](http://creativecommons.org/licenses/by/3.0/au/)
license, which permits its redistribution in this format. For a more recent
version of the data, you can check for updates
[here](http://data.gov.au/dataset/national-public-toilet-map).

The coordinates of the Australian cities plotted on the map are in the public
domain. I retrieved them from GeoHack (through Wikipedia) and embedded them in
the script directly.

## License

All source code is licensed under the project license (see the LICENSE.txt in
the parent directory). The resulting original image has licensing information
embedded in the output, and should therefore be respected. Derivative works
should contain some measure of attribution, at your judgment.

The raw data is copyright Government of Australia (2014), and is redistributed
here under the terms of the
[Creative Commons Attribution 3.0 Australia](http://creativecommons.org/licenses/by/3.0/au/)
license.
