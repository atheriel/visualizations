create_tiles <- function(df, row.size = 10) {
    if (!requireNamespace("dplyr"))
        stop("Requires the dplyr package.")
    if (!requireNamespace("data.table"))
        stop("Requires the data.table package.")
    
    df.new <- df %>%
        mutate(count = as.integer(round(count)),
               rows = count %/% row.size,
               remainder = count %% row.size) %>%
        arrange(desc(rows), desc(remainder)) %>%
        mutate(spacing = 1 + ifelse(remainder == 0, 0, 1),
               xoffset = lag(cumsum(rows + spacing)),
               xoffset = ifelse(is.na(xoffset), 0, xoffset))
   
    data.table::rbindlist(lapply(1:nrow(df.new), function(r) {
        into_tiles(df.new[r,], 5)
    }))
}

into_tiles <- function(df, row.size = 10) {
    coords <- expand.grid(x = df$xoffset + df$rows + 1,
                          y = 1:(df$remainder))
    
    if (df$rows != 0) {
        x = seq(1 + df$xoffset, length.out = df$rows)
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
