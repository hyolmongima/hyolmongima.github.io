HUGO ?= hugo

.PHONY: dev new note build publish clean

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

# make publish m="Volleybot: add limits figure"
# Fails before committing if the site has build warnings or the repo email is not the personal one.
publish:
	@test -n "$(m)" || (echo 'usage: make publish m="what changed"' && exit 1)
	@git config user.email | grep -q 'users.noreply.github.com' || (echo "refusing: this repo's git email is not the personal noreply address" && exit 1)
	$(HUGO) --minify --gc --panicOnWarning --destination /tmp/portfolio-publish-check --cleanDestinationDir
	git add -A
	git commit -m "$(m)"
	git push

clean:
	rm -rf public resources .hugo_build.lock
