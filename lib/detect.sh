#!/usr/bin/env bash

# shellcheck source=/dev/null
source "$bp_dir/lib/utils/json.sh"

detect_yarn_lock() {
  local build_dir=$1
  [[ -f "$build_dir/yarn.lock" ]]
}

write_detect_toml() {
  local package_json=$1
  local detect_toml=$2

  mkdir -p $(dirname "$detect_toml")

  build_script=$(json_get_key "$build_dir/package.json" ".scripts.build")
  run_script=$(json_get_key "$build_dir/package.json" ".scripts.start")

  if [[ $build_script ]] ; then
    cat <<TOML >> "$detect_toml"
[[build]]
command = "yarn build"
TOML
  fi

  if [ "null" != "$(jq -r .scripts.start < "$package_json")" ]; then
    cat <<TOML >> "$detect_toml"
[[run]]
type = "web"
command = "yarn start"
TOML
  fi
}
