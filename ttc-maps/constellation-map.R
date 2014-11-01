QUIET = FALSE

# ===------------------------------------------------------=== #
# Load additional packages and the font.
# ===------------------------------------------------------=== #

if (!QUIET) write("--- Loading required packages and fonts.",
                  file = "")

library(methods)
library(ggplot2)
library(gridExtra, quietly = TRUE)
suppressPackageStartupMessages(
    library(showtext)
)

# Envy Code R is a thin monospaced font, mostly used for programming. But it
# looks stylish and fits the graphic in this case.
font.add("custom", regular = "Envy Code R.ttf")

# ===------------------------------------------------------=== #
# Read in the TTC Stop data and construct the atribution string.
# ===------------------------------------------------------=== #

if (!QUIET) write("--- Loading stop data.",
                  file = "")

ttc.stops <- read.csv(gzfile("stops.txt.xz"), header = TRUE,
                      stringsAsFactors = FALSE)

attribution <- paste(
    scan(file = "AUTHOR.txt", what = character(), sep = "\n", quiet = TRUE),
    "Data: Toronto Open Data Portal, 2014",
    "You may redistribute this graphic under the terms of the CC-by-SA license.",
    sep = "\n"
)

# ===------------------------------------------------------=== #
# Construct graphic
# ===------------------------------------------------------=== #

if (!QUIET) write("--- Constructing graphic.", file = "")

# We create a graphic with a title and subtext using the arrangeGrob object.
graphic <- arrangeGrob(
    # The graphic itself is just two layers of points, one small one in the
    # forefront with one larger, mostly transparent one behind it.
    ggplot(ttc.stops, aes(x = stop_lon, y = stop_lat)) +
        geom_point(colour = "white", size = 4, alpha = 0.01) +
        geom_point(colour = "white", size = 0.5) +
        # Since this is a map, we don't want the coordinates to be distorted.
        coord_equal() +
        # Set the theme to remove most of the plot elements.
        theme(panel.background = element_rect(fill = "gray10", colour = NA),
              plot.background = element_rect(fill = "gray10", colour = NA),
              # Remove titles, ticks, gridlines, and borders.
              axis.text = element_blank(),
              axis.title = element_blank(),
              axis.ticks = element_blank(),
              panel.grid = element_blank(),
              panel.border = element_blank(),
              # Set margins so that the graphic fills the whole space.
              plot.margin = unit(c(0, 0, -0.5, -0.5), "line")
        ),
    # We can create a two-line title using a textGrob.
    main = textGrob(
        label = c("A Transit Constellation",
                  "TTC Stops in the City of Toronto"),
        hjust = c(0, 0), vjust = c(1, 1), x = unit(c(0.04, 0.04), "npc"),
        y = unit(c(0, -2.1), "line"),
        gp = gpar(fontsize = c(15, 8), fontfamily = "custom",
                  fontface = "plain", lineheight = 0.9, col = "white")),
    # And similarly, a more complex subtext using another textGrob.
    sub = textGrob(
        x = unit(0.99, "npc"), y = unit(0.2, "npc"),
        hjust = 1, vjust = 0,
        gp = gpar(fontsize = 6, fontfamily = "custom", lineheight = 1.0,
                  col = "white"),
        label = attribution)
)

if (!QUIET) write("--- Writing output to <stop-constellation-raw.png>.",
                  file = "")

# We can set the background of the PNG using the "bg" parameter.
png("stop-constellation-raw.png",
    width = 7 * 300, height = 5 * 300, res = 300, bg = "gray10")
# The custom font is rendered by the `showtext` library.
showtext.begin()
print(graphic)
showtext.end()
tmp <- dev.off()
