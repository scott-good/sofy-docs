export JEKYLL_VERSION=4.0
docker run \
  --rm \
  -e "JEKYLL_ENV=docker" \
  --volume="$PWD/docs:/srv/jekyll" \
  --volume="$PWD/docs/vendor/bundle:/usr/local/bundle" \
  -p 4000:4000 \
  -it jekyll/jekyll:$JEKYLL_VERSION \
  jekyll serve --config  _config.yml,_config-local.yml