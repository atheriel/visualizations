QUIET = FALSE

# ===------------------------------------------------------=== #
# Load additional packages.
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

# Minion Pro is the standard serif Adobe font.
font.add("minion", regular = "MinionPro-Regular.otf")

# ===------------------------------------------------------=== #
# Read in the data.
# ===------------------------------------------------------=== #

load("pop.rda")

attribution <- paste(
    scan(file = "AUTHOR.txt", what = character(), sep = "\n", quiet = TRUE),
    "Data: Statistics Canada (2013)",
    "You may redistribute this graphic under the terms of the CC-by-SA license.",
    sep = "\n"
)

# ===------------------------------------------------------=== #
# Population pyramids.
# ===------------------------------------------------------=== #

final.pop <- pop %>%
  filter(geo %in% c("Alberta", "New Brunswick")) %>%
  # Normalize to age bins as a share of the total population in that year.
  group_by(sex, year, geo) %>%
  mutate(pop = pop / sum(pop)) %>%
  ungroup() %>%
  arrange(geo, sex, year, age)
# ===------------------------------------------------------=== #
# Construct graphic
# ===------------------------------------------------------=== #

if (!QUIET) write("--- Constructing graphic.", file = "")

# We create a graphic with a title and subtext using the arrangeGrob object.
graphic <- arrangeGrob(
    ggplot(final.pop, aes(x = age, fill = sex)) +
    geom_bar(aes(y = pop), stat = "identity", position = "identity",
             color = "gray10", size = 0.1,
             data = filter(final.pop, sex == "Males")) +
    geom_bar(aes(y = -1 * pop), stat = "identity", position = "identity",
             color = "gray10", size = 0.1,
             data = filter(final.pop, sex == "Females")) +
    facet_grid(geo ~ year, scales = "fixed") +
    coord_flip() +
    scale_fill_brewer(palette = "Pastel1") +
    labs(x = NULL, y = NULL, title = NULL, fill = NULL) +
    theme_bw() +
    theme(axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),
          strip.background = element_rect(fill = "gray90", colour = "gray10"),
          strip.text = element_text(hjust = 0.5, vjust = 0.8, size = 14),
          # Add a little bit more space between the provincial rows.
          panel.margin.y = unit(0.02, unit = "npc"),
          legend.position = "none"),
    # Complex title using a textGrob.
    main = textGrob(
        label = "Provincial Population Pyramids",
        hjust = 0, vjust = 1, x = unit(0.01, "npc"),
        y = unit(0, "line"),
        gp = gpar(fontsize = 14, fontfamily = "minion",
                  fontface = "bold", col = "black")),
    # And similarly, a more complex subtext using another textGrob.
    sub = textGrob(
        x = unit(0.01, "npc"), y = unit(0.2, "npc"),
        hjust = 0, vjust = 0,
        gp = gpar(fontsize = 6, fontfamily = "minion", lineheight = 1.0,
                  col = "black"),
        label = attribution)
)

if (!QUIET) write("--- Writing output to <pyramids-raw.png>.", file = "")

png("pyramids-raw.png", width = 7 * 300, height = 7 * 300, res = 300)
# The custom font is rendered by the `showtext` library.
showtext.begin()
print(graphic)
showtext.end()
tmp <- dev.off()

