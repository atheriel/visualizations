library(ggplot2)
library(grid)
library(RColorBrewer)
library(dplyr)

toilets.raw <- read.csv(file.choose(),
                        header = TRUE,
                        stringsAsFactors = FALSE)

toilets <- toilets.raw %>%
    mutate(long = Longitude, lat = Latitude,
           free = !as.logical(PaymentRequired)) %>%
    select(ToiletID, long, lat, free)

bin.breaks <- c(0, 5, 10, 50, 100, 500, 1000, 10000)

ggplot(toilets, aes(x = long, y = lat)) +
    geom_hex(aes(fill = cut(..count..,
                               c(0, 5, 10, 50, 100, 500, 1000, 10000))),
                bins = 30, colour = NA,
                alpha = 1.0) +
    coord_equal() +
    labs(fill = NULL) +
    scale_fill_brewer(
        palette = "OrRd",
        labels = c("<5      ", "5-9     ", "10-49   ", "50-99   ",
                   "100-499 ", "500-999 ", "1000+  ")
    ) +
    theme(panel.background = element_rect(fill = "gray90", colour = NA),
          plot.background = element_rect(fill = "gray90", colour = NA),
          # Remove titles, ticks, gridlines, and borders.
          axis.text = element_blank(),
          axis.title = element_blank(),
          axis.ticks = element_blank(),
          panel.grid = element_blank(),
          panel.border = element_blank(),
          # Move the legend somewhere nice.
          legend.position = c(0.3, 0.1),
          legend.direction = "horizontal",
          legend.background = element_rect(fill = NA, colour = NA),
          legend.key = element_rect(fill = NA, colour = NA),
          # Set margins so that the graphic fills the whole space.
          plot.margin = unit(c(0, 0, -0.5, -0.5), "line")
    )
