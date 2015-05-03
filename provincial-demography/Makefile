RSCRIPT = Rscript

.PHONY: all clean

all: pyramids

# ===------------------------------------------------------=== #
# Targets.
# ===------------------------------------------------------=== #

pyramids: pyramids.png

pyramids.png: pyramids-raw.png
	convert pyramids-raw.png -resize 1024 pyramids.png

pyramids-raw.png: pyramids.R AUTHOR.txt pop.rda
	$(RSCRIPT) pyramids.R

pop.rda: pop.R 00520005-eng.csv.xz
	$(RSCRIPT) pop.R

AUTHOR.txt:
	echo "You must supply an AUTHOR.txt file with your desired attribution info."
	exit 1

# ===------------------------------------------------------=== #
# Source data.
# ===------------------------------------------------------=== #

00520005-eng.csv.xz:
	wget "http://www20.statcan.gc.ca/tables-tableaux/cansim/csv/00520005-eng.zip"
	unzip 00520005-eng.zip
	xz -z 00520005-eng.csv
	rm 00520005-eng.zip 00520005-eng.csv

# ===------------------------------------------------------=== #
# Clean up all generated files.
# ===------------------------------------------------------=== #

clean:
	rm pyramids.png pyramids-raw.png pop.rda
