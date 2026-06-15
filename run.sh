#!/usr/bin/env bash
#
# Run the Jekyll site locally.
#
# Prefers native Jekyll (run.sh). Falls back to Docker when Ruby/Jekyll
# is not installed on the host, so no system Ruby toolchain is required.
#
# Usage:
#   ./run.sh           # start the dev server (http://localhost:4000)
#   ./run.sh stop      # stop the Docker container (if used)
#   ./run.sh logs      # follow the Docker container logs
#   ./run.sh build     # one-off production build into ./_site
#
set -euo pipefail

# Move to the script's directory so it works from anywhere.
cd "$(dirname "$0")"

PORT=4000
HOST=0.0.0.0
IMAGE=jekyll/jekyll:4.2.2
CONTAINER=jekyll-qmaruf

start_native() {
  echo ">> Using native Jekyll"
  bundle install
  bundle exec jekyll serve --host "$HOST" --port "$PORT" --livereload
}

start_docker() {
  echo ">> Ruby/Jekyll not found on host — using Docker ($IMAGE)"
  # Remove any stale container with the same name.
  docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
  echo ">> Starting container (first run installs gems, ~30-40s)..."
  docker run --rm --name "$CONTAINER" \
    -v "$PWD":/srv/jekyll -w /srv/jekyll \
    -p "$PORT":"$PORT" \
    "$IMAGE" \
    sh -lc "bundle install && bundle exec jekyll serve --host $HOST --port $PORT"
}

case "${1:-serve}" in
  stop)
    docker rm -f "$CONTAINER" >/dev/null 2>&1 && echo "Stopped." || echo "No container running."
    ;;
  logs)
    docker logs -f "$CONTAINER"
    ;;
  build)
    if command -v jekyll >/dev/null 2>&1 || command -v bundle >/dev/null 2>&1; then
      JEKYLL_ENV=production bundle exec jekyll build
    else
      docker run --rm -v "$PWD":/srv/jekyll -w /srv/jekyll -e JEKYLL_ENV=production \
        "$IMAGE" sh -lc "bundle install && bundle exec jekyll build"
    fi
    echo "Built into ./_site"
    ;;
  serve|"")
    echo ">> Site will be available at http://localhost:$PORT"
    if command -v bundle >/dev/null 2>&1 && command -v ruby >/dev/null 2>&1; then
      start_native
    elif command -v docker >/dev/null 2>&1; then
      start_docker
    else
      echo "ERROR: need either Ruby+Bundler or Docker installed." >&2
      exit 1
    fi
    ;;
  *)
    echo "Usage: ./run.sh [serve|stop|logs|build]" >&2
    exit 1
    ;;
esac
