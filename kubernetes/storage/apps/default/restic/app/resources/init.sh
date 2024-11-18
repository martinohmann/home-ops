#!/bin/sh

set -e

users_file="${1:-users}"
htpasswd_file="${2:-.htpasswd}"
temp_file="$(mktemp)"

trap 'rm -f "$temp_file"' EXIT INT

chmod 0600 "$temp_file"

while IFS=':' read -r username password; do
  htpasswd -B -b "$temp_file" "$username" "$password"
done < "$users_file"

mv "$temp_file" "$htpasswd_file"
