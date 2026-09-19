.DEFAULT_GOAL := all

.PHONY: all
all: build run
	@echo "Building"

.PHONY: lock
lock: ## Re-solve dependencies into dune.lock/ after changing them in dune-project
	dune pkg lock

.PHONY: build
build: ## Build the project, including non installable libraries and executables
	dune build --root .

.PHONE: assets
assets:
	mkdir -p output output/2024 output/2025 output/2027
	cp -r asset/. output/
	cp -r data/2024/media/* output/2024
	cp -r data/2025/media/* output/2025
	cp -r data/2027/media/* output/2027
	rm -rf output/*/*-original output/*/README.md

.PHONY: css
css:
	mkdir -p output/css
	dune exec -- tailwindcss -m -c tailwind.config.js -i src/css/styles.css -o output/css/main.css


.PHONY: run
run: css assets
	mkdir -p output/privacy
	dune exec main
	cp output/css/main.css output/css/main.$(shell md5sum output/css/main.css | cut -d' ' -f1).css
	@echo "Replacing '/css/main.css' with '/css/main.$(shell md5sum output/css/main.css | cut -d' ' -f1).css' in all *.html files in output..."
	find output -name '*.html' -exec sed -i 's/\/css\/main.css/\/css\/main.$(shell md5sum output/css/main.css | cut -d' ' -f1).css/g' {} \;


.PHONY: clean
clean: ## Clean build artifacts and other generated files
	dune clean --root .

.PHONY: fmt
fmt: ## Format the codebase with ocamlformat
	dune fmt

.PHONY: watch
watch: ## Watch for the filesystem and rebuild on every change
	dune build @run -w --force --no-buffer

.PHONY: deploy
deploy: run ## Build and upload output/ to DEPLOY_TARGET (user@host:/path/)
	@test -n "$(DEPLOY_TARGET)" || (echo "Set DEPLOY_TARGET=user@host:/path/to/webroot/" && exit 1)
	rsync -av output/ $(DEPLOY_TARGET)
