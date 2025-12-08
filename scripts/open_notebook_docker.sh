#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/setup_guide/docker-compose.yml"
COMPOSE_DIR="$(dirname "$COMPOSE_FILE")"
ENV_FILE="$COMPOSE_DIR/docker.env"
ENV_EXAMPLE="$COMPOSE_DIR/docker.env.example"

# Auto-generate docker.env if missing
if [[ ! -f "$ENV_FILE" ]]; then
  if [[ -f "$ENV_EXAMPLE" ]]; then
    echo "⚠️  Setup: 'docker.env' not found. Creating it from default template..."
    cp "$ENV_EXAMPLE" "$ENV_FILE"
    echo "✅  Created: $ENV_FILE"
    echo "ℹ️   (Optional) Edit this file to add API keys (OpenAI/Anthropic)."
  else
    echo "❌ Error: Neither '$ENV_FILE' nor '$ENV_EXAMPLE' found. Configuration missing."
    exit 1
  fi
fi

open_url() {
  local url="$1"
  local browser="${OPEN_NOTEBOOK_BROWSER:-}"
  local env_opts=()

  env_opts+=("DISPLAY=${DISPLAY-:0}")
  [[ -n "${WAYLAND_DISPLAY-}" ]] && env_opts+=("WAYLAND_DISPLAY=$WAYLAND_DISPLAY")
  env_opts+=("XAUTHORITY=${XAUTHORITY-:$HOME/.Xauthority}")

  run_with_env() {
    if [[ "${#env_opts[@]}" -gt 0 ]]; then
      nohup env "${env_opts[@]}" "$@" "$url" >/dev/null 2>&1 &
    else
      nohup "$@" "$url" >/dev/null 2>&1 &
    fi
  }

  if [[ -n "$browser" ]] && command -v "$browser" >/dev/null 2>&1; then
    run_with_env "$browser"
    return
  fi

  for candidate in zen-browser zenbrowser xdg-open firefox chromium-browser google-chrome google-chrome-stable; do
    if command -v "$candidate" >/dev/null 2>&1; then
      run_with_env "$candidate"
      return
    fi
  done
}

wait_for_http() {
  local url="$1"
  local timeout=${2:-30}
  local sleep_interval=1
  local elapsed=0

  while (( elapsed < timeout )); do
    if curl -fsS --max-time 2 "$url" >/dev/null 2>&1; then
      return 0
    fi
    sleep "$sleep_interval"
    (( elapsed += sleep_interval ))
  done
  return 1
}

usage() {
  cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  start     Pull (if needed) and start the Open Notebook stack in detached mode
  stop      Bring the stack down and free the ports/volumes
  restart   stop, then start
  status    Show docker compose status for the stack
  logs      Tail the last 40 lines from the stack (pass additional args to docker compose logs)
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

cmd="$1"
shift

case "$cmd" in
  start)
    docker compose -f "$COMPOSE_FILE" up -d
    if wait_for_http http://localhost:8502 30; then
      open_url http://localhost:8502
    else
      echo "WARNING: Open Notebook did not respond at http://localhost:8502 after waiting"
    fi
    ;;
  stop)
    docker compose -f "$COMPOSE_FILE" down
    ;;
  restart)
    "$0" stop
    "$0" start
    ;;
  status)
    docker compose -f "$COMPOSE_FILE" ps
    ;;
  logs)
    docker compose -f "$COMPOSE_FILE" logs --no-color --tail 40 "$@"
    ;;
  *)
    usage
    exit 1
    ;;
esac
