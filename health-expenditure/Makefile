RSCRIPT = Rscript

.PHONY: all clean

all: spie

# ===------------------------------------------------------=== #
# Targets.
# ===------------------------------------------------------=== #

spie: spie.png

spie.png: spie-raw.png
	convert spie-raw.png -resize 1024 spie.png

spie-raw.png: spie.R \
              AUTHOR.txt \
              pop_exp_canada_2011.csv
	$(RSCRIPT) spie.R

AUTHOR.txt:
	echo "You must supply an AUTHOR.txt file with your desired attribution info."
	exit 1

# ===------------------------------------------------------=== #
# Clean up all generated files.
# ===------------------------------------------------------=== #

clean:
	rm spie.png
	rm spie-raw.png
