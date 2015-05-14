#!/bin/bash

set -e
set -x

# clone app
git clone $1 /app

cd /app

if [ ! -f solution.rb ]; then
  echo "No se encontró el archivo solution.rb en la raiz del proyecto." >> /ukku/data/error.txt
  exit 1
fi

cp /ukku/data/makeitreal_spec.rb .
cp /ukku/data/spec_helper.rb .

rspec makeitreal_spec.rb --format j --fail-fast --out /ukku/data/result.json 2> /ukku/data/error.txt