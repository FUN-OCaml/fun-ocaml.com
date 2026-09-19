# fun-ocaml.com

Static site for the FUN OCaml conference, generated with OCaml (`.mlx` templates via `html_of_jsx`) and Tailwind CSS.

## Build

Requirements: [dune](https://dune.build) 3.24 or newer. Dependencies, including the OCaml compiler and the Tailwind CSS CLI, are locked in `dune.lock/` and fetched by dune on the first build. No opam needed.

```bash
make        # builds everything into output/
```

`make` compiles the generator, builds the CSS, copies static assets and media, and renders all pages plus `sitemap.xml` into `output/`.

After changing dependencies in `dune-project`, run `make lock` to re-solve them and commit the updated `dune.lock/`.

## Layout

Each edition is self-contained and stays compiled, so past years remain online as archives:

- `data/{year}/` – people, sessions, schedule and sponsors (YAML), parsed by `data{year}.ml`
- `data/{year}/media/` – images and slides, published under `/{year}/`
- `templates/{year}/` – page templates for that edition
- `asset/` – static files copied as-is to the site root (favicons, `robots.txt`, per-year fonts and images)
- `src/main.ml` – renders every page; the current edition is the one written to `output/index.html`

### Adding a new edition

1. Copy `data/{prev}/` and `templates/{prev}/` to the new year and rename the libraries in their `dune` files.
2. Add the new libraries to `src/dune`, render the new home and session pages in `src/main.ml`, and point `output/index.html` at the new edition.
3. Set the previous edition's canonical URL to `https://fun-ocaml.com/{prev}/` and lower its priority in the sitemap.
4. Add a `cp -r data/{year}/media/* output/{year}` line to the `assets` target in the `Makefile`.

### Media

Put full-resolution originals in `*-original/` directories next to the optimized versions. They stay in the repo but are not published.

- Avatars: 512×512 px, quality 85
  ```bash
  convert input.jpg -resize 512x512^ -gravity center -extent 512x512 -quality 85 output.jpg
  ```
- Logos: at most ~600 px on the longest side

## Deploy

```bash
make deploy DEPLOY_TARGET=user@host:/path/to/webroot/
```

This builds the site and uploads `output/` to the web server (Caddy) with rsync. The production target is not part of this repo; maintainers keep it in a local, gitignored `deploy.sh`.

The Bluesky handle `@fun-ocaml.com` is verified by a DNS TXT record (`_atproto.fun-ocaml.com`), not by a file on the site.
