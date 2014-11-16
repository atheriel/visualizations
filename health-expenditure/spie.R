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

# Minion and Myriad are the standard sans-serif and serif fonts from Adobe.
font.add("myriad", regular = "MyriadPro-Regular.otf",
         bold = "MyriadPro-Bold.otf", italic = "MyriadPro-It.otf")
font.add("minion", regular = "MinionPro-Regular.otf",
         bold = "MinionPro-Bold.otf", italic = "MinionPro-It.otf")

# ===------------------------------------------------------=== #
# Read in the CIHI data and construct the atribution string.
# ===------------------------------------------------------=== #

if (!QUIET) write("--- Loading required data.", file = "")

attribution <- paste(
    scan(file = "AUTHOR.txt", what = character(), sep = "\n", quiet = TRUE),
    "Data: Canadian Institute for Health Information (2013)",
    "You may redistribute this graphic under the terms of the CC-by-SA license.",
    sep = "\n"
)

# Data culled form Appendix C.17 and Table E.1.14 of the CIHI report's data
spie.data <- read.csv("pop_exp_canada_2011.csv", header = TRUE)

# (Optional) Change the levels from "F" and "M" to more complete labels:
levels(spie.data$sex) <- c("Women", "Men")

# Reorganize the data (we can skip the factor column "sex", since it does not
# make a difference):
spie.data$bin[1:20] <- rev(spie.data$bin[1:20])
spie.data$exp[1:20] <- rev(spie.data$exp[1:20])
spie.data$pop[1:20] <- rev(spie.data$pop[1:20])

# Calculate the population percentage and cumulative percentage for each entry:
spie.data$popshare <- spie.data$pop / sum(spie.data$pop)
spie.data$cumpop <- cumsum(spie.data$popshare)

# And the expenditure share as well
spie.data$expshare <- spie.data$exp / sum(spie.data$exp)

# Compute the radius
spie.data$r_exp <- sqrt(spie.data$expshare / spie.data$popshare)

# ===------------------------------------------------------=== #
# Construct graphic
# ===------------------------------------------------------=== #

if (!QUIET) write("--- Constructing graphic.", file = "")

# We create a graphic with a title and subtext using the arrangeGrob object.
graphic <- arrangeGrob(
    ggplot(spie.data, aes(x = cumpop - 0.5 * popshare, y = r_exp, fill = sex)) +
    geom_bar(aes(width = popshare, y = 1),
             color = NA, stat = "identity", alpha = 0.2) +
    geom_bar(aes(width = popshare),
             color = "grey10", size = 0.1, stat = "identity") +
    annotate("segment", linetype = 3, size = 0.25, lineend = "round",
             x = -Inf, xend = Inf, y = sqrt(c(0.5, 1.0)),
             yend = sqrt(c(0.5, 1.0))) +
    coord_polar(theta = "x") +
    scale_x_continuous(labels = spie.data$bin,
                       breaks = spie.data$cumpop - 0.5 * spie.data$popshare) +
    scale_fill_brewer(palette = "Pastel1") +
    labs(x = NULL, y = NULL, title = NULL) +
    # Arrow to the 90+ group, and a text blurb:
    annotate("segment", linetype = 1, size = 0.25, x = 0.94, xend = 0.9925,
             y = sqrt(6.0) - 0.05, yend = sqrt(6.0),
             arrow = arrow(ends = "last", length = unit(0.3, "line"))) +
    annotate("text", size = 3, x = 0.935, y = sqrt(6.0) - 0.05,
             hjust = 1, vjust = 1, family = "minion",
             label = paste("If we take the ratio of the share of public health",
                           "spending to the share of the population for",
                           "five-year age groups, we spend at more",
                           "than 6:1 on those over 90.", sep = "\n")) +
    # Arrow to the 80-84 group, and a text blurb:
    annotate("segment", linetype = 1, size = 0.25, x = 0.03, xend = 0.095,
             y = sqrt(4.0), yend = sqrt(4.0),
             arrow = arrow(ends = "first", length = unit(0.3, "line"))) +
    annotate("text", size = 3, x = 0.1, y = sqrt(4.0), hjust = 0, 
             family = "minion",
             label = "And more than 4:1 on those over 80.") +
    # Arrow to the 65-69 group, and a text blurb:
    annotate("segment", linetype = 1, size = 0.25, x = 0.855, xend = 0.93,
             y = sqrt(2.0), yend = sqrt(2.0) - 0.1,
             arrow = arrow(ends = "last", length = unit(0.3, "line"))) +
    annotate("text", size = 3, x = 0.85, y = sqrt(2.0), hjust = 1, 
             family = "minion",
             label = "In fact by 65 the ratio is already 2:1.") +
    # Text blurbs:
    annotate("segment", linetype = 1, size = 0.25, x = 0.31, xend = 0.275,
             y = 1.05, yend = 1.5,
             arrow = arrow(ends = "first", length = unit(0.3, "line"))) +
    annotate("text", size = 3, x = 0.27, y = 1.16, hjust = 0, vjust = 0,
             family = "minion",
             label = paste("Only below age 55 is the ratio less than 1:1.",
                           "(The break-even point is illustrated by the",
                           "pale inner circle.)", sep = "\n")) +
    # Arrow to the inner circle and text blurb:
    annotate("segment", linetype = 1, size = 0.25, x = 0.65, xend = 0.62,
             y = 1.25, yend = sqrt(0.5) + 0.05,
             arrow = arrow(ends = "last", length = unit(0.3, "line"))) +
    annotate("text", size = 3, x = 0.7, y = 1.2, hjust = 1, vjust = 1,
             family = "minion",
             label = paste("In fact most of the remainder cost less than",
                           "50% of their share. (Women are more",
                           "expensive in their youth primarily",
                           "because of childbirth.)", sep = "\n")) +
    # Babies text and arrow:
    annotate("segment", linetype = 1, size = 0.25, x = 0.495, xend = 0.455,
             y = 1.53, yend = 1.83,
             arrow = arrow(ends = "first", length = unit(0.3, "line"))) +
    annotate("text", size = 3, x = 0.45, y = 1.8, hjust = 0, vjust = 1,  
             family = "minion",
             label = "(Babies themselves are expensive, too.)") +
    # Explaining the graph itself:
    annotate("text", size = 3, x = 0.55, y = 2.2, hjust = 1, vjust = 1,  
             family = "minion", lineheight = 0.95, fontface = "italic",
             label = paste("Age increases in five-year intervals as you move",
                           "up the graph, with the addition of 90+ and <1",
                           "groups at the top and bottom, respectively.",
                           sep = "\n")) +
    annotate("text", size = 3, x = 0.05, y = 3.0, hjust = 0, vjust = 1,
             family = "minion", lineheight = 0.95, fontface = "italic",
             label = "Women are in red, men are in purple.") +
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
    ),
    # We can create a two-line title using a textGrob.
    main = textGrob(
        label = c(paste("The Pressures of an Ageing Population:",
                        "Public Health Spending in Canada"),
                  paste("The width of the slice corresponds to the population",
                        "size, and its area to the share of government health",
                        "spending devoted to that group.")),
        hjust = c(0, 0), vjust = c(1, 1), x = unit(c(0.01, 0.01), "npc"),
        y = unit(c(0, -2.1), "line"),
        gp = gpar(fontsize = c(15, 8), fontfamily = c("myriad", "minion"),
                  fontface = c("bold", "italic"), lineheight = 0.9)),
    # And similarly, a more complex subtext using another textGrob.
    sub = textGrob(
        x = unit(0.01, "npc"), y = unit(0.2, "npc"),
        hjust = 0, vjust = 0,
        gp = gpar(fontsize = 8, fontfamily = "minion", lineheight = 0.9,
                  col = "black"),
        label = attribution)
)

if (!QUIET) write("--- Writing output to <spie-raw.png>.", file = "")

png("spie-raw.png", width = 7 * 300, height = 7 * 300, res = 300)
# The custom font is rendered by the `showtext` library.
showtext.begin()
print(graphic)
showtext.end()
tmp <- dev.off()
