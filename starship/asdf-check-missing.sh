missing=$(cut -d' ' -f1 .tool-versions | while read plugin; do
  if ! asdf plugin list | grep -q "^$plugin$"; then
    echo "$plugin"
  fi
done | tr '\n' ' ' | sed 's/ *$//')

if [[ -n "$missing" ]]; then
  echo "⚠️ asdf missing: $missing"
fi
