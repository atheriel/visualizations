RSCRIPT = Rscript

.PHONY: all

all: constellation

# ===------------------------------------------------------=== #
# Targets for the "Constellation" Map of TTC Stops.
# ===------------------------------------------------------=== #

constellation: stop-constellation.png

stop-constellation.png: stop-constellation-raw.png
	convert stop-constellation-raw.png -resize 1024 stop-constellation.png

stop-constellation-raw.png: constellation-map.R \
                            AUTHOR.txt \
                            stops.txt.xz
	$(RSCRIPT) constellation-map.R

# ===------------------------------------------------------=== #
# Clean up all generated files.
# ===------------------------------------------------------=== #

clean:
	rm stop-constellation.png
	rm stop-constellation-raw.png
