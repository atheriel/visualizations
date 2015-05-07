QUIET = FALSE

# ===------------------------------------------------------=== #
# Load additional packages.
# ===------------------------------------------------------=== #

library(dplyr, warn.conflicts = FALSE)

# ===------------------------------------------------------=== #
# Extract the relevant data from the full data set.
# ===------------------------------------------------------=== #

if (!QUIET) write("--- Extracting relevant data.", file = "")

raw.data <- read.csv("00520005-eng.csv.xz",
                     header = TRUE, na.strings = "..",
                     colClasses = c("integer",
                                    rep("character", times = 6),
                                    "numeric"))

# We want to do the aggregation ourselves, so the relevant ages are at the
# individual year level.
relevant.ages <- c("Under 1 year (x 1,000)",
                   paste(1:99, "years (x 1,000)"),
                   "100 years and over (x 1,000)")

# This is the correct level order for the age buckets used.
CIHI.AGES <- c("<1", "1-4", "5-9", "10-14", "15-19", "20-24",
               "25-29", "30-34", "35-39", "40-44", "45-49",
               "50-54", "55-59", "60-64", "65-69", "70-74",
               "75-79", "80-84", "85-89", "90+")

# And the order of the provinces.
PROVS <- c("British Columbia", "Alberta", "Saskatchewan", "Manitoba",
           "Ontario", "Quebec", "New Brunswick", "Nova Scotia",
           "Prince Edward Island", "Newfoundland and Labrador")

# This is a mapping of individual years to the five-year age bins used by the
# Canadian Institute for Health Information, a nice breakdown.
cihi.age.map <- data.frame(
  AGE = relevant.ages,
  age = factor(c("<1", rep("1-4", times = 4), rep("5-9", times = 5),
                 rep("10-14", times = 5), rep("15-19", times = 5),
                 rep("20-24", times = 5), rep("25-29", times = 5),
                 rep("30-34", times = 5), rep("35-39", times = 5),
                 rep("40-44", times = 5), rep("45-49", times = 5),
                 rep("50-54", times = 5), rep("55-59", times = 5),
                 rep("60-64", times = 5), rep("65-69", times = 5),
                 rep("70-74", times = 5), rep("75-79", times = 5),
                 rep("80-84", times = 5), rep("85-89", times = 5),
                 rep("90+", times = 11)),
               levels = CIHI.AGES)
)

pop <- raw.data %>%
  filter(PROJECT == "Projection scenario M1: medium-growth, 1991/1992 to 2010/2011 trends",
         SEX != "Both sexes",
         Ref_Date %in% c(2015, 2025, 2035),
         AGE %in% relevant.ages) %>%
  left_join(cihi.age.map, by = "AGE") %>%
  select(geo = GEO, year = Ref_Date, sex = SEX, age, pop = Value) %>%
  # Collapse to age bins.
  group_by(geo, year, sex, age) %>%
  summarise(pop = sum(as.numeric(pop))) %>%
  ungroup() %>%
  mutate(geo = factor(geo, levels = PROVS))

# ===------------------------------------------------------=== #
# Save to disk.
# ===------------------------------------------------------=== #

if (!QUIET) write("--- Saving clean data to <pop.rda>.", file = "")

save(pop, file = "pop.rda", compress = "xz")
