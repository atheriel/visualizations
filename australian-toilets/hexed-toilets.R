QUIET = FALSE

# ===------------------------------------------------------=== #
# Load additional packages and the font.
# ===------------------------------------------------------=== #

if (!QUIET) write("--- Loading required packages and fonts.", file = "")

library(methods)
library(ggplot2)
library(grid)
library(gridExtra, quietly = TRUE)
library(dplyr, warn.conflicts = FALSE)
suppressPackageStartupMessages(
    library(showtext)
)

# Envy Code R is a thin monospaced font, mostly used for programming. But it
# looks stylish and fits the graphic in this case. Minion Pro is the standard
# serif Adobe font.
font.add("custom", regular = "Envy Code R.ttf")
font.add("customsf", regular = "MinionPro-Regular.otf")

# ===------------------------------------------------------=== #
# Read in the toilet data and construct the atribution string.
# ===------------------------------------------------------=== #

if (!QUIET) write("--- Loading required data.", file = "")

attribution <- paste(
    scan(file = "AUTHOR.txt", what = character(), sep = "\n", quiet = TRUE),
    "Data: Government of Australia (2014) and GeoHack (2014)",
    "You may redistribute this graphic under the terms of the CC-by-SA license.",
    sep = "\n"
)

toilets <-
    read.csv("toiletmap.csv",
             header = TRUE, stringsAsFactors = FALSE) %>%
    mutate(long = Longitude, lat = Latitude,
           free = !as.logical(PaymentRequired)) %>%
    select(ToiletID, long, lat, free)

poi <- data.frame(
    name = c("Perth", "Sydney", "Melbourne", "Brisbane", "Adelaide",
             "Alice\nSprings", "Darwin", "Hobart\n(Tasmania)"),
    long = c(115.858889, 151.209444, 144.963056, 153.027778, 138.601, 133.87,
             130.833333, 147.325),
    lat  = c(-31.952222, -33.859972, -37.813611, -27.467917, -34.929, -23.7,
             -12.45, -42.880556),
    vjust = c(1, 1, 0, 0.5, 0, 0.5, 0.5, 0),
    hjust = 0.5
)

# ===------------------------------------------------------=== #
# Construct graphic
# ===------------------------------------------------------=== #

if (!QUIET) write("--- Constructing graphic.", file = "")

# We create a graphic with a title and subtext using the arrangeGrob object.
graphic <- arrangeGrob(
    ggplot(toilets, aes(x = long, y = lat)) +
    stat_binhex(aes(fill = cut(..count..,
                               c(0, 5, 10, 50, 100, 500, 1000, Inf))),
                bins = 30, colour = NA,
                alpha = 0.8) +
    coord_equal() +
    labs(fill = NULL) +
    scale_fill_brewer(
        palette = "OrRd",
        labels = c("<5 ", "5-9 ", "10-49 ", "50-99 ",
                   "100-499 ", "500-999 ", "1000+  ")
    ) +
    geom_text(aes(x = long, y = lat, label = name, vjust = vjust,
                  hjust = hjust), data = poi,
              family = "custom", lineheight = 0.8, size = 4) +
    theme(panel.background = element_rect(fill = "gray90", colour = NA),
          plot.background = element_rect(fill = "gray90", colour = NA),
          # Remove titles, ticks, gridlines, and borders.
          axis.text = element_blank(),
          axis.title = element_blank(),
          axis.ticks = element_blank(),
          panel.grid = element_blank(),
          panel.border = element_blank(),
          # Move the legend somewhere nice.
          legend.text = element_text(family = "custom", size = 8),
          legend.position = c(0.35, 0.1),
          # legend.position = c(0.27, 0.975),
          legend.direction = "horizontal",
          legend.background = element_rect(fill = NA, colour = NA),
          legend.key = element_rect(fill = NA, colour = NA),
          legend.key.size = unit(0.5, "line"),
          # Set margins so that the graphic fills the whole space.
          plot.margin = unit(c(0, 0, -0.5, -0.5), "line")
    ),
    # We can create a two-line title using a textGrob.
    main = textGrob(
        label = c("Australia, In Public Toilets",
                  "(You'll Just Have to Hold It 'Till Perth)"),
        hjust = c(0, 0), vjust = c(1, 1), x = unit(c(0.04, 0.04), "npc"),
        y = unit(c(0, -1.4), "line"),
        gp = gpar(fontsize = c(18, 10), fontfamily = "customsf",
                  fontface = "plain", col = "black")),
    # And similarly, a more complex subtext using another textGrob.
    sub = textGrob(
        x = unit(0.01, "npc"), y = unit(0.2, "npc"),
        hjust = 0, vjust = 0,
        gp = gpar(fontsize = 7, fontfamily = "customsf", lineheight = 1.0,
                  col = "black"),
        label = attribution)
)

if (!QUIET) write("--- Writing output to <australia-raw.png>.", file = "")

# We can set the background of the PNG using the "bg" parameter.
png("australia-raw.png",
    width = 7 * 300, height = 6.5 * 300, res = 300, bg = "gray90")
# The custom font is rendered by the `showtext` library.
showtext.begin()
print(graphic)
showtext.end()
tmp <- dev.off()
