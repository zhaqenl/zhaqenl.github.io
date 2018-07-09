.PHONY: all clean rebuild

FILES=$(wildcard src/*.md)
BUILDER=emem

OG_TITLE="$$(head -1 $<)"
OG_TYPE="article"
OG_IMAGE="https://avatars0.githubusercontent.com/u/29517051"
ANALYTICS="121960562-1"

%.html: src/%.md
	$(BUILDER) \
          --og-title $(OG_TITLE) --og-type $(OG_TYPE) \
          -D $(OG_TITLE) \
          -K "zhaqenl, raymund, martinez, raymund martinez" \
          --og-url "https://zhaqenl.github.io/$$(basename $< .md).html" \
          --og-image $(OG_IMAGE) \
          --analytics $(ANALYTICS) \
          -RFiamuo "$$(basename $< .md).html" \
          $<

all:
	$(BUILDER) -r
	$(MAKE) $(MFLAGS) -C en
	parallel --will-cite "$(MAKE) {/.}.html" ::: $(FILES)

clean:
	find . -maxdepth 1 -name '*.html' ! -name 'sitemap.html' ! -name 'index.html' -exec rm -vf {} \;
	rm -rvf static
	$(MAKE) -C en $@

rebuild:
	$(MAKE) clean
	$(MAKE)
