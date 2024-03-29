.PHONY: all clean

FILES=$(filter-out src/footer.md src/index.md, $(wildcard src/*.md))
BUILDER=java -jar ~/bin/emem.jar

OG_TITLE="$$(head -1 $<)"
OG_TYPE="article"
OG_IMAGE="https://avatars0.githubusercontent.com/u/29517051"
ANALYTICS="121960562-1"

all:
	parallel --will-cite "$(MAKE) {/.}.html" ::: $(FILES)
	$(BUILDER) \
	  -D "Enhancing an inherently flawful object is stacking books on top of a ball in hopes of achieving a flat top." \
	  -K "zhaqenl, raymund, martinez, raymund martinez, sporadic sciolisms" \
	  --og-title "Sporadic Sciolisms" \
	  --og-type $(OG_TYPE) \
	  --og-url "https://zhaqenl.github.io/en/" \
	  --og-image $(OG_IMAGE) \
	  --analytics $(ANALYTICS) \
	  --lang "en" \
	  -RFiamuo index.html \
	  src/index.md src/footer.md

%.html: src/%.md
	if [[ ! -d "$$(basename $< .md)" ]]; then mkdir "$$(basename $< .md)"; fi
	$(BUILDER) \
	  -D $(OG_TITLE) \
	  -K "$$(cat $<.dat)" \
	  --og-title $(OG_TITLE) \
	  --og-type $(OG_TYPE) \
	  --og-url "https://zhaqenl.github.io/en/$$(basename $< .md)/" \
	  --og-image $(OG_IMAGE) \
	  --analytics $(ANALYTICS) \
	  --lang "en" \
	  -RFiamuo "$$(basename $< .md)/index.html" \
	  $< src/footer.md

clean:
	rm -vf *.html
	find . -maxdepth 1 -type d ! -path . ! -iname src -exec rm -rf {} \;
