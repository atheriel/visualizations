RSCRIPT = Rscript

.PHONY: all

all: toilets

# ===------------------------------------------------------=== #
# Targets for the "Constellation" Map of TTC Stops.
# ===------------------------------------------------------=== #

toilets: australia.png

australia.png: australia-raw.png
	convert australia-raw.png -resize 1024 australia.png

australia-raw.png: hexed-toilets.R \
                   AUTHOR.txt
	$(RSCRIPT) hexed-toilets.R

# ===------------------------------------------------------=== #
# Clean up all generated files.
# ===------------------------------------------------------=== #

clean:
	rm australia.png
	rm australia-raw.png
