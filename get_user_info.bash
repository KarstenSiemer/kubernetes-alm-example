#!/bin/bash

# Get the user ID
USER_ID=$(id -u)

# Get the group ID
GROUP_ID=$(id -g)

# Create JSON output
JSON_OUTPUT=$(cat <<EOF
{
  "user_id": "$USER_ID",
  "group_id": "$GROUP_ID"
}
EOF
)

# Print the JSON
echo "$JSON_OUTPUT" | jq .
