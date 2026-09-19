(lang dune 3.17)

(name fun_ocaml)

(source
 (github sabine/fun-ocaml.com))

(authors
 "Sabine")

(maintainers "Sabine")

(generate_opam_files false)

(package
 (allow_empty)
 (name fun_ocaml)
 (synopsis "Fun OCaml Website")
 (description
  "This package generates the HTML pages found at https://fun-ocaml.com")
 (depends
  (ocaml
   (>= 4.14.0))
  dune
  bos
  fpath
  tailwindcss
  html_of_jsx
  mlx
  fmt
  ptime
  (cmarkit
   (>= 0.2.0))
  ppx_deriving_yaml
  ))

(dialect
 (name mlx)
 (implementation
  (extension mlx)
  (preprocess
   (run mlx-pp %{input-file}))))

(pin
 (url "https://github.com/tmattio/opam-tailwindcss/archive/4c3007877d616c271205046ff492759c96fe7a76.tar.gz")
 (package
  (name tailwindcss)))
