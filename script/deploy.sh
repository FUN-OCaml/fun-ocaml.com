#!/bin/sh
make
rsync -vr output/ fun-ocaml.com:/var/www-fun-ocaml/
