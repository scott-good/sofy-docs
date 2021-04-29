export JEKYLL_VERSION=4.0
docker run \
  --rm \
  --volume="$PWD/docs:/srv/jekyll" \
  --volume="$PWD/docs/vendor/bundle:/usr/local/bundle" \
  -p 4000:4000 \
  -it jekyll/jekyll:$JEKYLL_VERSION \
  jekyll serve