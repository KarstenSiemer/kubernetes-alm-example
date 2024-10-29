#!/usr/bin/env bash

TARGETS=("$@")
declare -A results  # Associative array to store the target and its corresponding output

# Loop through each target and capture the output
for TARGET in "${TARGETS[@]}"; do
  ip_address=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "${TARGET}")
  results["$TARGET"]="$ip_address"
done

# Construct a JSON string manually
json_output="{"
for key in "${!results[@]}"; do
  json_output+="\"$key\":\"${results[$key]}\","
done

# Remove the trailing comma and close the JSON object
json_output="${json_output%,}}"

# Output the result as JSON
echo "$json_output" | jq .
