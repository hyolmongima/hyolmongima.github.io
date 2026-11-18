HUGO ?= hugo

.PHONY: dev new note build clean

# Live preview at http://localhost:1313, drafts included.
dev:
	$(HUGO) server -D --bind 0.0.0.0 --navigateToChanged --renderToMemory

# make new p=visual-inertial-odometry
new:
	@test -n "$(p)" || (echo "usage: make new p=slug" && exit 1)
	$(HUGO) new content projects/$(p)/index.md

# make note p=ekf-derivation
note:
	@test -n "$(p)" || (echo "usage: make note p=slug" && exit 1)
	$(HUGO) new content notes/$(p)/index.md

# Production build into public/, drafts excluded.
build:
	$(HUGO) --minify --gc --cleanDestinationDir

clean:
	rm -rf public resources .hugo_build.lock
