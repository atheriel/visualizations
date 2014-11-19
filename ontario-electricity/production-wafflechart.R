QUIET = FALSE

# ===------------------------------------------------------=== #
# Load additional packages, utilities and the fonts.
# ===------------------------------------------------------=== #

if (!QUIET) write("--- Loading required packages and fonts.", file = "")

library(methods)
library(ggplot2)
library(grid)
library(gridExtra, quietly = TRUE)
library(dplyr, warn.conflicts = FALSE)
library(data.table, warn.conflicts = FALSE)
suppressPackageStartupMessages(
    library(showtext)
)

# Source the utilities file (which contains some helper functions).
source("util.R")

# Envy Code R is a thin monospaced font, mostly used for programming. But it
# looks stylish and fits the graphic in this case. Minion Pro is the standard
# serif Adobe font.
font.add("custom", regular = "Envy Code R.ttf")
font.add("minion", regular = "MinionPro-Regular.otf")
font.add("zapf", regular = "ZapfChanceryStd-Roman.ttf")

energy.raw <- data.frame(
    kind = c("Conservation", "Oil &\nNatural Gas",
             "Solar\n(1 TW/h)", "Bioenergy", "Wind",
             "Hydroelectric", "Nuclear", "Coal"),
    count = c(8.6, 16.6, 1.0, 2.0, 5.4, 35.5, 90.8, 3.0)
)

energy <- create_tiles(energy.raw, row.size = 5)

labels <- data.frame(
    kind = unique(energy$kind),
    x = c(10, 24.5, 31.5, 35.5, 38, 40, 42, 46),
    y = c(3, 3, 3, -1.5, 7.5, -1.5, 4.5, 3),
    size = c(16, 16, 12, 12, 12, 12, 12, 12)
)

arrows <- data.frame(
    x = c(35.5, 38, 40, 42, 44.7),
    xend = c(35.5, 38, 40, 42, 46),
    y = c(0.3, 5.7, 0.3, 2.7, 1),
    yend = c(-0.8, 7.0, -0.8, 4, 2)
)

graphic <-
    ggplot() +
    geom_tile(aes(x = x, y = y, fill = kind), data = energy,
              width = 1, height = 1, colour = "gray50", alpha = 0.9) +
    scale_fill_brewer(palette = "Spectral") +
    coord_equal() +
    # These are the labels for the different kinds of power, as
    # defined above.
    geom_text(aes(x = x, y = y, label = kind), data = labels, size = 3,
              lineheight = 0.9,
              family = "zapf") +
    # These are the arrows to the last few labels. They are
    # defined in a data frame above.
    geom_segment(aes(x = x, xend = xend, y = y, yend = yend),
                 data = arrows, linetype = 1, size = 0.15,
                 arrow = arrow(ends = "first",
                               length = unit(0.15, "line"))) +
    theme(panel.background = element_rect(fill = NA, colour = NA),
          plot.background = element_rect(fill = NA, colour = NA),
          # Remove titles, ticks, gridlines, and borders.
          axis.text = element_blank(),
          axis.title = element_blank(),
          axis.ticks = element_blank(),
          panel.grid = element_blank(),
          panel.border = element_blank(),
          # Move the legend somewhere nice.
          legend.position = "none",
          # Set margins so that the graphic fills the whole space.
          plot.margin = unit(c(0, 0, -0.5, -0.5), "line")
    )


if (!QUIET) write("--- Writing output to <waffle-raw.png>.", file = "")

png("waffle-raw.png", width = 7 * 300, height = 2 * 300, res = 300)
# The custom font is rendered by the `showtext` library.
showtext.begin()
print(graphic)
showtext.end()
tmp <- dev.off()

