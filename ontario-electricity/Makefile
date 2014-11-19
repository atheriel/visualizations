RSCRIPT = Rscript

.PHONY: all clean

all: electricity

# ===------------------------------------------------------=== #
# Targets.
# ===------------------------------------------------------=== #

electricity: waffle.png

waffle.png: waffle-raw.png
	convert waffle-raw.png -resize 1024 waffle.png

waffle-raw.png: production-wafflechart.R \
                AUTHOR.txt
	$(RSCRIPT) production-wafflechart.R

AUTHOR.txt:
	echo "You must supply an AUTHOR.txt file with your desired attribution info."
	exit 1

# ===------------------------------------------------------=== #
# Clean up all generated files.
# ===------------------------------------------------------=== #

clean:
	rm waffle.png
	rm waffle-raw.png
