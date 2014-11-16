RSCRIPT = Rscript

.PHONY: all clean

all: toilets

# ===------------------------------------------------------=== #
# Targets.
# ===------------------------------------------------------=== #

toilets: australia.png

australia.png: australia-raw.png
	convert australia-raw.png -resize 1024 australia.png

australia-raw.png: hexed-toilets.R \
                   AUTHOR.txt \
                   toiletmap.csv.xz
	$(RSCRIPT) hexed-toilets.R

AUTHOR.txt:
	echo "You must supply an AUTHOR.txt file with your desired attribution info."
	exit 1

# ===------------------------------------------------------=== #
# Clean up all generated files.
# ===------------------------------------------------------=== #

clean:
	rm australia.png
	rm australia-raw.png
