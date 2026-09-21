journal() {
  local file="$JOURNAL_DIR/index.txt"
  local command="${1:-open}"

  case "$command" in
    open)
      nvim "$file"
      ;;

    today)
      journal_history "$file" "$(date '+%m-%d')"
      ;;

    [0-9][0-9]-[0-9][0-9])
      journal_history "$file" "$command"
      ;;

    sync)
      journal_sync
      ;;

    *)
      echo "usage: journal [today|MM-DD|sync]" >&2
      return 1
      ;;
  esac
}

journal_history() {
  local file="$1"
  local md="$2"

  printf '\n'

  awk -v md="$md" '
    /^[0-9]{4}-[0-9]{2}-[0-9]{2} / {
      match_day = substr($0, 6, 5) == md

      if (match_day && found) {
        print "----------------------------------------"
        print ""
      }

      if (match_day) {
        found = 1
      }

      show = match_day
    }

    show {
      print
    }
  ' "$file"
}

journal_sync() {
  git -C "$JOURNAL_DIR" pull --ff-only || return 1

  git -C "$JOURNAL_DIR" add index.txt

  if ! git -C "$JOURNAL_DIR" diff --cached --quiet; then
    git -C "$JOURNAL_DIR" commit \
      -m "journal update: $(date '+%Y-%m-%d %H:%M')" || return 1
  fi

  git -C "$JOURNAL_DIR" push origin
}

jr() {
  cat "$JOURNAL_DIR/index.txt"
}
