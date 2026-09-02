#!/bin/bash -e
# AP Cybersecurity — close out today's log entry.
# Run it in the last minutes of the period, or when you stop working at home.
# It carries your task list forward so you can check things off.
#
#   bash scripts/sign-off.sh M14   after a class: adds the class entry
#   bash scripts/sign-off.sh       working at home: sign-off only

# Work from the top of the repository no matter where you ran this from.
cd "$(dirname "$0")/.."

FILENAME="logs/$(date +'%Y-%m-%d').log.md"

if [ ! -f "$FILENAME" ]; then
  echo "No sign-on entry for today. Run scripts/start-entry.sh first."
  exit 1
fi

# Pull the task list out of the most recent entry so you can check items off
# instead of retyping them. Empty checkboxes are dropped.
TASKS=$(awk '/^# /{buf=""} /^- \[/{ if ($0 !~ /^- \[ \] *$/) buf=buf $0 "\n"} END{printf "%s", buf}' "$FILENAME")
[ -z "$TASKS" ] && TASKS="- [ ] "

MEETING="$1"      # e.g. M14. Leave it off when you are working at home.

{
  echo ""
  echo "# $(date +'%A, %B %e, %Y %I:%M %p')"
  echo ""
  printf '%s\n' "$TASKS"

  # The four labels have to be spelled exactly like this. study-guide.sh looks
  # for them in December, and it will not find what it cannot match.
  if [ -n "$MEETING" ]; then
    echo ""
    echo "## ${MEETING}: "
    echo ""
    echo "**Today's one idea:** "
    echo ""
    echo "**Terms released:** "
    echo ""
    echo "**Shaky:** "
    echo ""
    echo "**Did:** "
  fi

  echo ""
  echo "Signing off."
  echo ""
  echo "**AI use:** none."
} >> "$FILENAME"

if command -v code > /dev/null; then
  code "$FILENAME"
elif command -v nano > /dev/null; then
  nano "$FILENAME"
else
  echo "Wrote $FILENAME. Open it in your editor."
fi

echo ""
if [ -n "$MEETING" ]; then
  echo "Finish the heading, then the four lines. Your own words on the one idea;"
  echo "the terms are on your notes sheet. Leave Shaky in even when it is empty."
fi
echo "Check off what you finished, say in one honest word why anything is not"
echo "finished, replace the AI line if you used it, then:"
echo "    git add logs && git commit && git push"