library(grid)
library(ggplot2)
library(data.table, warn.conflict = FALSE)
library(dplyr, warn.conflict = FALSE)

into.tiles <- function(df, row.size = 10) {
    coords <- expand.grid(x = df$xoffset + df$rows + 1,
                          y = 1:(df$remainder))
    
    if (df$rows != 0) {
        x = seq(1 + df$xoffset, length.out = df$rows)
        print(x)
        filled <- expand.grid(x = x,
                              y = 1:row.size)
        if (df$remainder == 0) {
            coords <- filled
        } else {
            coords <- rbind(coords, filled)
        }
    }
    
    coords$kind <- df$kind
    coords
}

ROW.SIZE <- 5

energy.raw <- data.frame(
    kind = c("Conservation", "Oil &\nNatural Gas", "Solar\n(1 TW/h)", "Bioenergy",
             "Wind", "Hydroelectric", "Nuclear", "Coal"),
    production = c(8.6, 16.6, 1.0, 2.0, 5.4, 35.5, 90.8, 3.0)
)

energy <- energy.raw %>%
    mutate(production = as.integer(round(production)),
           rows = production %/% ROW.SIZE,
           remainder = production %% ROW.SIZE) %>%
    arrange(desc(rows), desc(remainder)) %>%
    mutate(spacing = 1 + ifelse(remainder == 0, 0, 1),
           xoffset = lag(cumsum(rows + spacing)),
           xoffset = ifelse(is.na(xoffset), 0, xoffset))

ex <- rbindlist(lapply(1:nrow(energy), function(r) {
    into.tiles(energy[r,], 5)
}))

labels <- data.frame(
    kind = energy$kind,
    x = c(10, 24.5, 31.5, 35.5, 38, 40, 42, 46),
    y = c(3, 3, 3, -1, 7, -1, 4.5, 3)
)

arrows <- data.frame(
    x = c(35.5, 38, 40, 42, 44.7),
    xend = c(35.5, 38, 40, 42, 46),
    y = c(0.3, 5.7, 0.3, 2.7, 1),
    yend = c(-0.5, 6.5, -0.5, 4, 2)
)

ggplot() +
    geom_tile(aes(x = x, y = y, fill = kind), data = ex,
              width = 1, height = 1, colour = "black") +
    scale_fill_brewer(palette = "Spectral") +
    coord_equal() +
    # These are the labels for the different kinds of power, as
    # defined above.
    geom_text(aes(x = x, y = y, label = kind), data = labels) +
    # These are the arrows to the last few labels. They are
    # defined in a data frame above.
    geom_segment(aes(x = x, xend = xend, y = y, yend = yend),
                 data = arrows, linetype = 1, size = 0.25,
                 arrow = arrow(ends = "first",
                               length = unit(0.3, "line"))) +
    theme(panel.background = element_rect(fill = "gray50", colour = NA),
          plot.background = element_rect(fill = "gray50", colour = NA),
          # Remove titles, ticks, gridlines, and borders.
          axis.text = element_text(colour = "black"),
          axis.title = element_blank(),
          axis.ticks = element_blank(),
          panel.grid = element_blank(),
          panel.border = element_blank(),
          # Move the legend somewhere nice.
          legend.position = "none",
          # Set margins so that the graphic fills the whole space.
          plot.margin = unit(c(0, 0, -0.5, -0.5), "line")
    )
